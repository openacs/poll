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
                      $field_insert_list,
                      p_package_id => :package_id,
                      p_creation_user => :user_id
         );
         end;
   </querytext>

</fullquery>

</queryset>
