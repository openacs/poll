<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="del_poll">
    <querytext>
    select poll__delete(:poll_id);
    </querytext>
</fullquery>

</queryset>
