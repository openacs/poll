-- A very basic and simple polling module based on the OACS 3.x
-- code.
--
-- $Id$

--
-- DATAMODEL
--

-- poll: object_type
select acs_object_type__create_type (
    'poll',
    'Poll',
    'Polls',
    'acs_object',
    'polls',
    'poll_id',
    null,
    'f',
    null,
    null
);

-- polls: individual poll info.
create table polls (
       poll_id			integer
				references acs_objects (object_id) on delete cascade
				primary key,
       name			varchar(100) not null,
       question			text not null,
       -- make the dates NULL for an on-going poll
       start_date		timestamp,
       end_date			timestamp,
       enabled_p		boolean default 'f' not null,
       require_registration_p	boolean default 'f' not null,
       package_id		integer not null
                                references apm_packages on delete cascade
);

create index polls_package_id_index on polls (package_id);

-- poll_choices: possible answers for poll.
create table poll_choices (
       choice_id	  integer
			  primary key,
       poll_id		  integer not null references polls on delete cascade,
       label		  varchar(500) not null,
       sort_order	  integer not null
);

create sequence poll_choice_id_sequence;
create index poll_choices_index on poll_choices (poll_id, choice_id);

-- poll_user_choices: web site visitor answers
create table poll_user_choices (
       choice_id	       integer references poll_choices on delete cascade
			       not null,
       -- user_id can be NULL if we're not requiring registration
       user_id		       integer references users,
       ip_address	       varchar(50) not null,
       choice_date	       timestamp default current_timestamp not null
);

create index poll_user_choices_choice_index on poll_user_choices(choice_id);
create index poll_user_choices_user_index   on poll_user_choices(user_id);


--
-- FUNCTIONS
--

-- poll__new: create a new poll
create function poll__new (integer,varchar,text,timestamp,timestamp,boolean,boolean,integer,integer)
returns integer as '
declare
    p_poll_id			alias for $1;
    p_name			alias for $2;
    p_question			alias for $3;
    p_start_date		alias for $4;
    p_end_date			alias for $5;
    p_enabled_p			alias for $6;
    p_require_registration_p	alias for $7;
    p_package_id		alias for $8;
    p_creation_user		alias for $9;
    v_poll_id			polls.poll_id%TYPE;
begin
    if p_poll_id is null then
        select acs_object_id_seq.nextval 
        into   v_poll_id
        from   dual;
    else 
        v_poll_id := p_poll_id;
    end if; 

    v_poll_id := acs_object__new (
	v_poll_id,
	''poll'',
	null, -- defaults to null
	p_creation_user,
	null,
	p_package_id
    );

    insert into polls
        (poll_id, name, question, start_date, end_date,
	 enabled_p, require_registration_p, package_id)
    values
	(v_poll_id, p_name, p_question, p_start_date, p_end_date,
	 p_enabled_p, p_require_registration_p, p_package_id);

    return v_poll_id;

end;' language 'plpgsql';


-- poll__delete: nuke a poll
create function poll__delete (integer)
returns integer as '
declare
    p_poll_id	alias for $1;
begin

    -- All we need do is delete the acs_object since
    -- the cascade clause handles the rest.
    perform acs_object__delete(p_poll_id);

    return 0;

end;' language 'plpgsql';


-- poll__is_active_p: checks if a poll is active.
create function poll__is_active_p (timestamp, timestamp) returns boolean as '
declare
	start_date alias for $1;
	end_date alias for $2;
	v_result_p boolean;
begin
	v_result_p := ''t'';

	if (date_trunc(''day'', start_date) > current_timestamp)
	then v_result_p := ''f'';
	end if;

	if (date_trunc(''day'', end_date) < date_trunc(''day'', current_timestamp))
	then v_result_p := ''f'';
	end if;

	return v_result_p;
end;
' language 'plpgsql';


--
-- VIEWS
--

-- poll_info: includes active_p.
create view poll_info as
    select
        *,
        poll__is_active_p (start_date, end_date) as active_p,
	(poll__is_active_p (start_date, end_date) and enabled_p) as open_p
    from
        polls;
