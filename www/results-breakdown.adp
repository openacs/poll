<master>
<property name="title">Results Breakdown</property>
<property name="context">@context@</property>

  <table cellpadding=3 cellspacing=0 border=1 width=90% align="center">
      <tr>
          <td colspan=2><b>@question@</b>
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
		      <td valign=center align=left nowrap>&nbsp;<b>@percentage@%</b> (@results.votes@ votes)

</td>
	     	  </tr>
	      </table>
	  </td>
      </tr>
      <group column="label">
        <if @results.choice_votes@ gt 0>
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;@results.user@<if @results.choice_votes@ gt 1> (@results.choice_votes@)</if></td>
		</tr>
	</if>
      </group>
    </multiple>
      <tr>
	  <td colspan=2 align="center"><b>@total@ total votes</b></td>
      </tr>
</else>
  </table>
