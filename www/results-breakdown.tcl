ad_page_contract {

    Shows the breakdown of the results of a poll.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-11-01
} {
    poll_id:naturalnum
}

permission::require_permission -object_id $poll_id -privilege admin

#
# Show the results.
#
set total 0
set context [list [list "vote?poll_id=$poll_id" "Vote"] \
		 [list "results?poll_id=$poll_id" "Results"] Breakdown]

set question [db_string get_desc {
    select question from polls where poll_id = :poll_id}]

db_multirow results fetch_results {
    select
        c2.label,
        case when v.user_id is null then 'Unregistered Users'
    	     else p2.first_names || ' ' || p2.last_name || ' (' || p.email || ')' end
    	         as user,
    	(select count(*) from poll_user_choices where choice_id = v.choice_id) as votes,
        v.choice_votes
    from
    	(select c.choice_id, u.user_id, count(u.choice_id) as choice_votes
	 from poll_user_choices u
	      right join poll_choices c using (choice_id)
	 where c.poll_id = :poll_id
	 group by c.choice_id, u.user_id) as v inner join
    	poll_choices c2 using (choice_id) left join
    	parties p on v.user_id = p.party_id left join
    	persons p2 on v.user_id = p2.person_id
    order by
        votes desc, c2.sort_order;
} {
    incr total $choice_votes
}
