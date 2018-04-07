<master>
<property name="title">Polls</property>
<property name="context">@context@</property>

<script language="javascript">
<!--
    function confirm_delete(choice, votes, url) {
	var message = "Are you sure you want to delete the choice: '" + choice + "'?";
	if (votes > 0) {
	    message += " This will also delete " + votes + " votes.";
	} else {
	    message += " There are no votes for this choice.";
	}
	if (confirm(message)) {
	    location.href = url;
	}
    }
//-->
</script>

<formtemplate id="poll"></formtemplate>

<p>

<if @insert_p;literal@ false>

    <if @poll_choices:rowcount@ eq 0>
      <i>This poll currently has no choices.</i>
    </if>
    <else>
      Available choices for poll:
    </else>
      <ul>
        <if @write_p;literal@ true>
          <li><a href="poll_choice-ae?poll_id=@poll_id@&after=0">insert</a> a new poll choice.
        </if>
        <multiple name=poll_choices>
          <li>@poll_choices.label@
	    <if @write_p;literal@ true>
	      (<a href="poll_choice-ae?poll_id=@poll_id@&choice_id=@poll_choices.choice_id@">edit</a>
	       | <a href="javascript:confirm_delete('@poll_choices.label_js@', '@poll_choices.votes@', 'poll_choice-delete?poll_id=@poll_id@&choice_id=@poll_choices.choice_id@')">delete</a>
	       | <a href="poll_choice-ae?poll_id=@poll_id@&after=@poll_choices.sort_order@">insert after</a>
	        <if @poll_choices.sort_order@ ne 1>
	          | <a href="poll_choice-swap?poll_id=@poll_id@&choice_id=@poll_choices.choice_id@">switch up</a>
		</if>
	      )
	    </if>
	</multiple>
      </ul>
    </else>

</if>