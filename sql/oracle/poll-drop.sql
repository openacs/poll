-- drop SQL for poll package
--
--
-- 

-- drop all the poll data


drop package poll;

-- Drop the datamodel.
drop view poll_info;

drop table poll_user_choices;
drop trigger poll_coice_id_seq_trigger;
drop sequence poll_choice_id_sequence;
drop table poll_choices;

drop table polls;
/
show errors;

-- Drop the poll acs object type.
begin
acs_object_type.drop_type (
  object_type =>  'poll',
  cascade_p   =>   't'   
);
end;
/
show errors;

