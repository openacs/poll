<?xml version="1.0"?>

<queryset>

<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
<fullquery name="new_poll">

      <querytext>
       declare
       id integer;
       begin
       id :=  poll.new(
                      p_poll_id => :poll_id,
	              p_name => :name,
	              p_question => :question,
		      p_start_date => to_date(:start_date,'YYYY-MM-DD'),
                      p_end_date =>  to_date(:end_date,'YYYY-MM-DD'),
		      p_enabled => :enabled_p,
		      p_require_registration_p => :require_registration_p,
                      p_package_id => :package_id,
                      p_creation_user => :user_id
         );
         end;
   </querytext>

</fullquery>

</queryset>
