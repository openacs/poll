<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>
<fullquery name="del_poll">
          <querytext>
           begin
            poll.delete(p_poll_id => :poll_id);
           end;
           </querytext>
</fullquery>
</queryset>
  
