ad_require_permission $poll_id read

#
# 1) Generate the form for voting.
#
db_1row get_poll {
    select question,
    require_registration_p,
    case when open_p = 't' then 1 else 0 end as open_p
    from poll_info where poll_id = :poll_id}

set options [db_list_of_lists get_options {
	select
	    label, choice_id
	from
	    poll_choices
	where
	    poll_id = :poll_id
	order by
	    sort_order
}]

if { ![info exists poll_url] } {
    set poll_url ""
}

# We are being included from a page other than vote.
template::form create vote -has_submit 1 -action ${poll_url}vote

template::element create vote question -label "" \
	-widget inform -datatype text -value "<b>$question</b> (<a href=\"${poll_url}results?poll_id=$poll_id\">results</a>)"

template::element create vote choice_id -label " " \
	-widget radio -datatype text -options $options

template::element create vote poll_id -widget hidden \
	-datatype integer -value $poll_id

if { $open_p } {
    template::element create vote submit -label "Vote" \
	    -widget submit -datatype text
} else {
    template::element create vote closed -label "" \
	    -widget inform -datatype text -value "This poll is closed."
}

#
# 2) If the user has voted, then log the vote and go to
# the results page.
#
if { [template::form is_valid vote] } {

    # Check if the user is required to register.
    if { [string match "t" $require_registration_p] } {
	auth::require_login
    }

    # If the user is logged in, check to see if they've
    # already voted.  If not, check to see if they were cookied.
    set voted 0

    if { ![set user_id [ad_conn user_id]] } {
	set user_id ""
	if { ![empty_string_p [ad_get_cookie poll_${poll_id}]] } {
	    set voted 1
	}
    } else {
	if [db_string num_votes "select count(*) from poll_user_choices u, poll_choices c
			         where u.choice_id = c.choice_id and c.poll_id = :poll_id
			               and u.user_id = :user_id"] {
	    set voted 1
	}
    }

    if { !$voted && $open_p } {
	set choice_id  [template::element get_value vote choice_id]
	set ip_address [ad_conn peeraddr]

	db_dml log_vote "insert into poll_user_choices
			     (choice_id, user_id, ip_address)
	             	 values
                              (:choice_id, :user_id, :ip_address)"

	# Tag the user with a cookie.
	ad_set_cookie -max_age inf poll_${poll_id} $choice_id
    }

    ad_returnredirect "results?poll_id=$poll_id&voted=$voted"
}