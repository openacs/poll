<?xml version="1.0"?>

<queryset>

<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
<fullquery name="polls_select">

      <querytext>
select  poll_id, name, question,
        case when enabled_p = 't' then 1 else 0 end as enabled_p,
        case when active_p  = 't' then 1 else 0 end as active_p,
        case when acs_permission.permission_p(poll_id, :user_id, 'write')  = 't' then 1 else 0 end as edit_p,
        case when acs_permission.permission_p(poll_id, :user_id, 'delete') = 't' then 1 else 0 end as delete_p,
        (select count(*) from poll_choices c, poll_user_choices u
         where c.choice_id = u.choice_id and c.poll_id = p.poll_id) as votes
    from
        poll_info p
    where
        package_id = :package_id
    order by
        enabled_p desc, active_p desc, start_date desc, poll_id  
   </querytext>

</fullquery>

</queryset>
