ad_page_contract {

    Shows the results of a particular poll.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-01-13
} {
    poll_id:naturalnum
    {voted:naturalnum 0}
}

ad_require_permission $poll_id read

#
# Show the results.
#
set total 0
set context [list [list "vote?poll_id=$poll_id" "Vote"] Results]

set question [db_string get_desc {
    select question from polls where poll_id = :poll_id}]

db_multirow results fetch_results {
    select label,
           (select count(*) from poll_user_choices where choice_id = p.choice_id) as votes
    from poll_choices p
    where poll_id = :poll_id
    order by votes desc, sort_order
} {
    incr total $votes
}

#
# Check if the user has admin privileges on this poll.
#
set admin_p [permission::permission_p -object_id $poll_id -privilege admin]
