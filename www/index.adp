<master>
<property name="title">Polls</property>

<script language="javascript">
<!--
    function confirm_delete(poll, votes, url) {
	var message = "Are you sure you want to delete the poll '" + poll + "'?";
	if (votes > 0) {
	    message += " This will also delete " + votes + " votes.";
	} else {
	    message += " There are no votes for this poll.";
	}
	if (confirm(message)) {
	    location.href = url;
	}
    }
//-->
</script>

<if @polls:rowcount@ eq 0>
  <i>Sorry, but there are no polls available.</i>
</if>
<else>
  <ul>
    <multiple name=polls>
        <if @polls.archive_label_p@>
	  </ul>
	  <p><b>Archived/Future Polls</b>
	  <ul>
	</if>

        <if @polls.disabled_label_p@>
	  </ul>
	  <p><b>Disabled Polls</b>
	  <ul>
	</if>

      <li><a href="vote?poll_id=@polls.poll_id@">@polls.name@</a>: @polls.question@
	<if @polls.edit_p@ or @polls.delete_p@>
          (
	    <if @polls.edit_p@>
	      <a href="poll-ae?poll_id=@polls.poll_id@">edit</a>
	    </if>
	    <if @polls.delete_p@>
	        <if @polls.edit_p@>
	      |
		</if>
	      <a href="javascript:confirm_delete('@polls.name_js@', '@polls.votes@', 'poll-delete?poll_id=@polls.poll_id@')">delete</a>
	    </if>
	  )
	</if>
    </multiple>
  </ul>
</else>

<if @create_p@>
  <p><a href="poll-ae">Add</a> a new poll.
</if>
