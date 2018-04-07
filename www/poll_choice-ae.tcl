ad_page_contract {

    Displays a form for creating/editing a poll choice.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-01-13
} {
    poll_id:naturalnum
    choice_id:naturalnum,optional
    after:naturalnum,optional
}

permission::require_permission -object_id $poll_id -privilege write

#
# 1) Set up the form.
#
template::form create poll_choice

template::element create poll_choice label -label "Label" \
	-widget text -datatype text

template::element create poll_choice poll_id   -widget hidden -datatype integer \
	-value $poll_id
template::element create poll_choice choice_id -widget hidden -datatype integer
template::element create poll_choice after     -widget hidden -datatype integer -optional
template::element create poll_choice insert_p  -widget hidden -datatype integer

template::element create poll_choice submit -label "Save" \
	-widget submit -datatype text

#
# 2) If this is a request, set some default values.
#
if { [template::form is_request poll_choice] } {
    if { ![info exists choice_id] } {
	# This is an insert.  Get the next sequence value
	# for double-click protection.
	set choice_id [db_nextval poll_choice_id_sequence]
	set insert_p 1
	template::element set_value poll_choice after $after
    } else {
	# This is an update...
	db_1row fetch_info "
	    select 
	        label
	    from
	        poll_choices
	    where
	        choice_id = :choice_id
	"

	template::element set_value poll_choice label $label

	set insert_p 0
    }

    template::element set_value poll_choice choice_id $choice_id
    template::element set_value poll_choice insert_p  $insert_p
}

#
# 3) If this is a valid submission.
#
if { [template::form is_valid poll_choice] } {
    set label     [template::element get_value poll_choice label]
    set insert_p  [template::element get_value poll_choice insert_p]

    if { $insert_p } {
	if { ![db_string check_exists "select 1 from poll_choices where choice_id = :choice_id" -default "0"] } {

	    # "after" should be defined for all inserts.
	    incr after

	    db_transaction {
		db_dml incr_sort "update poll_choices set sort_order = sort_order + 1
		                  where sort_order >= :after and poll_id = :poll_id"

		db_dml new_choice "insert into poll_choices (choice_id, poll_id, label, sort_order)
	             values (:choice_id, :poll_id, :label, :after)"
	    }
	}
    } else {
	db_dml edit_choice "update poll_choices set label = :label where choice_id = :choice_id"
    }

    ad_returnredirect "poll-ae?poll_id=$poll_id"
}

#
# 5) Set the context bar.
#
if { [template::element get_value poll_choice insert_p] } {
    set action New
} else {
    set action Edit
}

set context [list [list "poll-ae?poll_id=$poll_id" "One Poll"] $action]