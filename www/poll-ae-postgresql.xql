<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>
  <fullquery name="new_poll">
        <querytext>
        
         select poll__new(
                         :poll_id,
                         $field_insert_list_pg,
                         :package_id,
                         :user_id
          ); 

       </querytext>
   </fullquery>
</queryset>
