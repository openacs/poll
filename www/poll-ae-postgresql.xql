<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>
  <fullquery name="new_poll">
        <querytext>
		 select poll__new(		
                         :poll_id,	
	                 :name,
	                 :question,
			 to_date(:start_date,'YYYY-MM-DD'),
                         to_date(:end_date,'YYYY-MM-DD'),
			 :enabled_p,
			 :require_registration_p,
                         :package_id,
                         :user_id
          ); 

       </querytext>
   </fullquery>
</queryset>
