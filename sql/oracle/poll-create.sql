-- A very basic and simple polling module based on the OACS 4.x code.
--
--
-- DATA MODEL

-- poll: object_type


begin
      acs_object_type.create_type (
           object_type    => 'poll',
           pretty_name    => 'POLL',
           pretty_plural  => 'POLLS',
           supertype      => 'acs_object',
           table_name     => 'POLLS',
           id_column      =>  'poll_id'
     );           
end;
/
show errors;

-- polls: individual poll info.

create table polls (
          poll_id	  integer  constraint polls_pk  primary key
                          constraint polls_poll_id_fk
                          references acs_objects (object_id),
           name			varchar(100) not null,
       question			varchar2(1500) not null,
       start_date		date ,
       end_date			date ,
       enabled_p		char(1)
                                default 'f'
                                constraint poll_enabl_p_chk
                                check(enabled_p in('t','f'))
                                not null ,
       require_registration_p	char(1) 
                                default 'f'
                                constraint poll_regist_p_chk
                                check(require_registration_p in('t','f'))
                                not null ,
       package_id              integer 
                               not null 
                    references apm_packages on delete cascade
);
/
show errors;

create index polls_package_id_index on polls (package_id);

-- poll_choices: possible answers for poll.
create table poll_choices (
       choice_id	  integer  primary key,
       poll_id		  integer not null references polls on delete cascade,
       label		  varchar(500) not null,
       sort_order	  integer not null
);

create sequence poll_choice_id_sequence;


create index poll_choices_index on poll_choices (poll_id, choice_id);

-- poll_user_choices: web site visitor answers
create table poll_user_choices (
       choice_id	    integer references poll_choices(choice_id) on delete cascade not null,
       -- user_id can be NULL if we're not requiring registration
       user_id		       integer references users(user_id),
       ip_address	       varchar(50) not null,
       choice_date	       date default sysdate not null
);

create index poll_user_choices_choice_index on poll_user_choices(choice_id);
create index poll_user_choices_user_index   on poll_user_choices(user_id);


--
-- FUNCTIONS
--

-- 
create or replace package poll
as
 function new (
    p_poll_id   in polls.poll_id%type,
    p_name      in polls.name%type,
    p_question  in polls.question%type,
    p_start_date in polls.start_date%type,
    p_end_date   in polls.end_date%type,
    p_enabled_p   in polls.enabled_p%type,
    p_require_registration_p in polls.require_registration_p%type,
    p_package_id  in polls.package_id%type,
    p_creation_user in acs_objects.creation_user%type default null
  ) return polls.poll_id%type;

  function is_active_p (
    p_start_date in date,
    p_end_date   in date
  ) return char;

   function is_poll_open_p (
      p_start_date in date,
      p_end_date   in date,
      p_enabled    in char
   ) return char ;

  procedure delete (
       p_poll_id in polls.poll_id%type
   ); 
   
  
end poll;
/
show errors;

create or replace package body poll
as
    function new (
    p_poll_id   in polls.poll_id%type,
    p_name      in polls.name%type,
    p_question  in polls.question%type,
    p_start_date in polls.start_date%type,
    p_end_date   in polls.end_date%type,
    p_enabled_p   in polls.enabled_p%type,
    p_require_registration_p in polls.require_registration_p%type,
    p_package_id  in polls.package_id%type,
    p_creation_user in acs_objects.creation_user%type default null
   ) return polls.poll_id%type
   is
      v_poll_id integer;
      begin
       if p_poll_id is null then
         select acs_object_id_seq.nextval 
            into   v_poll_id
         from   dual;
       else 
         v_poll_id := p_poll_id;
       end if; 

    v_poll_id := acs_object.new (
	object_id   => v_poll_id,
        object_type => 	'poll',
	creation_date => sysdate,
        creation_user => p_creation_user,
	context_id    => p_package_id
    );

    insert into polls
        (poll_id, name, question, start_date, end_date,
	 enabled_p, require_registration_p, package_id)
    values
	(v_poll_id, p_name, p_question, p_start_date, p_end_date,
	 p_enabled_p, p_require_registration_p, p_package_id);
      return v_poll_id;
   end new;

--
-- function is_active_p
--   
    function is_active_p (
      p_start_date in date,
      p_end_date   in date
    ) return char
    is
      	v_result_p char;
    begin

        v_result_p := 't';

       	if (p_start_date > sysdate)
     	then v_result_p := 'f';
	end if;

	if (p_end_date < sysdate )
	then v_result_p := 'f';
	end if;

	return v_result_p;

     end is_active_p;
--
-- function is_poll_open_p
--
     function is_poll_open_p(
       p_start_date in  date,
       p_end_date   in date,
       p_enabled    in char
     ) return char      
     is
        v_open_p char(1);
        v_active_p char;
        begin
          v_open_p := 'f';
          v_active_p := is_active_p(p_start_date,p_end_date);
             if (v_active_p = 't') and (p_enabled ='t' )
              then v_open_p := 't';
             end if;
          return v_open_p;
      end is_poll_open_p;
--
--  procedure delete
--
     procedure delete (
          p_poll_id in polls.poll_id%type
     )
     is
     begin
        -- delete from acs_permissions
        -- where object_id = poll.delete.p_poll_id;
        -- delete from polls
        -- where poll_id = poll.delete.p_poll_id;
         acs_object.delete(p_poll_id);
     end delete;
     
end poll;
/
show errors; 

create view poll_info as ( 
    select poll_id,name,question,start_date,end_date,enabled_p,require_registration_p,package_id,
      poll.is_active_p (polls.start_date, polls.end_date)   as active_p ,
      poll.is_poll_open_p (polls.start_date, polls.end_date,polls.enabled_p)   as open_p
    from  polls
);
/
show errors;



                      
