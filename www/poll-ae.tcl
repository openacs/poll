ad_page_contract {

    Displays a form for creating/editing a poll.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-01-13
} {
    poll_id:naturalnum,optional
}

#
# 1) Set some useful variables.
#
set fields {name question start_date end_date enabled_p require_registration_p}
set dfield ""
set pfiled ""

foreach field $fields {
    if { ![regexp date $field] } {
	lappend field_select_list $field
    } else {
	lappend field_select_list "to_char($field, 'YYYY MM DD') as $field"
    }
}

set field_select_list [join $field_select_list ", "]

set date_format "MONTH DD, YYYY"
set clock_format "%Y %m %d"
set survey_duration "1 week"

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]



#
# 2) Set up the form.
#
template::form create poll

template::element create poll name -label "Name" \
    -widget text -datatype text

template::element create poll question -label "Question" \
    -widget textarea -datatype text -html {rows 4 cols 40}

template::element create poll start_date -label "Start Date" \
    -widget date -datatype date -format $date_format -value [template::util::date::now] -optional

template::element create poll end_date -label "End Date" \
    -widget date -datatype date -format $date_format \
    -value [clock format \
		[clock scan $survey_duration -base [clock seconds]] -format $clock_format] \
    -optional

template::element create poll enabled_p -label " " \
    -widget checkbox -datatype text -options {{"Enabled" t}} -optional

template::element create poll require_registration_p -label " " \
    -widget checkbox -datatype text -options {{"Requires Registration" t}} -optional

template::element create poll poll_id  -widget hidden -datatype integer
template::element create poll insert_p -widget hidden -datatype integer

template::element create poll submit -label "Save" \
    -widget submit -datatype text

#
# 3) If this is a request, set some default values.
#
if { [template::form is_request poll] } {
    if { ![info exists poll_id] } {
	# This is an insert.  Get the next sequence value
	# for double-click protection.
	ad_require_permission $package_id create

	set poll_id [db_nextval acs_object_id_seq]
	set insert_p 1

	template::element set_value poll enabled_p "t"
    } else {
	ad_require_permission $poll_id write

	# This is an update...
	db_1row fetch_info "
	    select 
	        $field_select_list
	    from
	        polls
	    where
	        poll_id = :poll_id
	"

	foreach field $fields {
	    template::element set_value poll $field [set $field]
	}

	set insert_p 0
    }

    template::element set_value poll poll_id  $poll_id
    template::element set_value poll insert_p $insert_p
}

#
# 4) If this is a valid submission.
#
if { [template::form is_valid poll] } {
    foreach field $fields {
	set $field [template::element get_value poll $field]

	if { [regexp {_p$} $field] } {
	    if { [empty_string_p [set $field]] } {
		set $field "f"
	    }
	}

	if { ![regexp {_date$} $field] } {
	    lappend field_insert_list "p_$field => :$field"
            lappend field_insert_list_pg ":$field "
            lappend field_update_list "$field = :$field"
	}  else {
	    set dfield [template::util::date::get_property sql_date [set $field]]
            set pfield $dfield
	    lappend field_insert_list "p_$field => $dfield"
            lappend field_insert_list_pg "$pfield"
	    lappend field_update_list "$field = $dfield"
	}
    }
    
    set field_insert_list [join  $field_insert_list ", "]
    set field_insert_list_pg [join $field_insert_list_pg ", "]
    set field_update_list [join $field_update_list ", "]
    set insert_p [template::element get_value poll insert_p]

    set db_error 0

    if { $insert_p } {
	ad_require_permission $package_id create

	if { ![db_string check_exists "select 1 from polls where poll_id = :poll_id" -default "0"] } {
	    if { [catch {db_exec_plsql new_poll " " } ] } {
		set db_error 1
	    }
	}
    } else {
	ad_require_permission $poll_id write

	set sql "update polls set $field_update_list where poll_id = :poll_id"
  	if { [catch {db_dml edit_poll $sql}] } {
	    set db_error 1
	}
    }


    if { $db_error } {
	template::element set_error poll name "Sorry, but there was an error processing your request."
    } else {
  	ad_returnredirect "poll-ae?poll_id=$poll_id"
    }
}

#
# 5) Show the choices for this poll, if any.
#
if { ![set insert_p [template::element get_value poll insert_p]] } {
    set context Edit

    set write_p [ad_permission_p $poll_id write]

    db_multirow -extend label_js poll_choices list_poll_choices {
	select
	choice_id, label, sort_order,
	(select count(*) from poll_user_choices
	 where choice_id = c.choice_id) as votes
	from
	poll_choices c
	where
	poll_id = :poll_id
	order by
	sort_order
    } {
	regsub -all {'} $label {\'} label_js
    }

} else {
    set context "New"
}
