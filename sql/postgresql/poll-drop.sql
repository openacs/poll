--
-- Drop SQL for polls package.
--
-- $Id$
--

-- Drop all the poll data.
create function inline_0 ()
returns integer as '
declare
    v_poll_id	  polls.poll_id%TYPE;
    v_poll_cursor RECORD;
begin
    -- delete all the polls.
    FOR v_poll_cursor IN
        select poll_id
        from   polls
    LOOP
	-- all attached types/item are deleted in news.delete - modify there
       	PERFORM poll__delete(v_poll_cursor.poll_id);
    END LOOP;

    return 0;
end;
' language 'plpgsql';

select inline_0 ();
drop function inline_0 ();


-- Drop the functions.
select drop_package('poll');


-- Drop the datamodel.
drop view poll_info;

drop table poll_user_choices;

drop sequence poll_choice_id_sequence;
drop table poll_choices;

drop table polls;


-- Drop the poll acs object type.
select acs_object_type__drop_type (
    'poll', -- object_type
    't'     -- cascade_p
);