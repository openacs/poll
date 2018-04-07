<master>
<property name="title">Results</property>
<property name="context">@context@</property>

  <table cellpadding=3 cellspacing=0 border=1 width=90% align="center">
      <tr>
          <td colspan=2><b>@question@</b>
<if @voted@>
  (You have already voted.)
</if>
	  </td>
      </tr>
<if @total@ eq 0>
      <tr>
	  <td colspan=2><i>Sorry, but there have been no votes..</i></td>
      </tr>
</if>
<else>
    <multiple name="results">
      <tr>
          <td height=10 nowrap>@results.label@&nbsp;&nbsp;</td>
          <td width=100%>
              <table width=100% cellspacing=0 cellpadding=0 border=0>
		  <tr>
		      <td bgcolor=blue width="<%=[set percentage [format %.0f [expr (@results.votes@.0/@total@.0) * 100]]]%>%"></td>
		      <td valign=center align=left nowrap>&nbsp;<b>@percentage@%</b> (@results.votes@ votes)</td>
	     	  </tr>
	      </table>
	  </td>
      </tr>
    </multiple>
      <tr>
	  <td colspan=2 align="center"><b>@total@ total votes</b>
		<if @admin_p;literal@ true>(<a href="results-breakdown?poll_id=@poll_id@">breakdown</a>)</if>
	  </td>
      </tr>
</else>
  </table>
