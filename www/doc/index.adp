<master>
<property name=title>Poll</property>

<h2>Poll</h2>

by <a href="http://www.infiniteinfo.com/">Infiniteinfo, Inc.</a>
<br>Oracle port by <a href="mailto:madhu@azri.biz">Madhu S</a>

<hr>

<h3>The Big Idea</h3>

This is a very simple polling module which:
<ul>
<li>allows administrators the ability to add, edit, and remove polls as well as
<li>add, edit, and remove poll choices;
<li>allows users to respond to a poll question by picking from a list
of available choices;
<li>allows both users and administrators to view the results of the poll.
</ul>

<h3>Datamodel and Permissions</h3>

The datamodel is very simple, consisting basically of the following
tables:
<ul>
<li>polls: poll information
<li>poll_choices: possible answers for a poll
<li>poll_user_choices: web site visitor answers (or votes)
</ul>

<p>For simplicity, polls are <i>acs_objects</i>, but poll choices and
votes are not.  Also, this package does not create any custom
permissions.

<p>You must have <i>create</i> permission for the package in order to
create a new poll.  You must have <i>write</i> permission on a given
poll in order to edit the poll information or add/edit/delete poll
choices.  And you must have <i>delete</i> permission in order to
remove a poll.

<p>In practical use, it is envisioned that a group or
user will be granted <i>admin</i> permissions for the package, which
would allow them to fully manage all polls.

<p>Lastly, the package is instance-aware, meaning that each instance
of the polls module contains its own polls.

<h3>User Interface</h3>

To add a poll:
<ul>
<li>Assuming you have the proper permission, go to the poll index page
and click on <i>Add a new poll</i>.
<li><i>Name</i> is required and is a short identifier for the poll (eg,
"Club Size").
<li><i>Question</i> is also required (eg, "How many members are in your
club?").
<li>The <i>Start Date</i> and <i>End Date</i> define how long the poll
will run.  Leaving the end date blank indicates that the poll will
never expire.  Leaving the start date blank indicates that the poll
should start immediately.
<li>If the <i>Enabled</i>" flag is unchecked, then the poll is
disabled and will never be shown to regular users.
<li>Setting the <i>Requires Registration</i> flag will only allow
registered site users to answer the poll.
<li>After saving the poll, you can add poll choices by clicking on
<i>insert a new poll choice</i>.
<li>Poll choices can be edited, deleted, and re-ordered.
</ul>

<p>To edit a poll:
<ul>
<li>Click on the <i>edit</i> link next to the desired poll.
<li>Edit the poll information as desired.
<li>Edit and re-order the poll choices.
<li>Deleting a poll choice will also delete its corresponding votes,
if any.  You will be asked to confirm the deletion.
</ul>

<p>To remove a poll:
<ul>
<li>Click on the <i>delete</i> link next to the desired poll.
<li>Deleting a poll will also delete its corresponding poll choices
and votes, if any.  You will be asked to confirm the deletion.
</ul>

<p>To take a poll:
<ul>
<li>Click on the poll name from the poll index page.
<li>Select an option (required) and click on <i>Vote</i>
<li>If <i>Requires Registration</i> is disabled, you will be taken to
the results page which summarizes all the votes to date.  Otherwise,
you will be asked to login before your vote will be accepted.
<li>You can also simply click on the <i>results</i> link without
voting.
<li>Duplicate votes are currently detected in 2 ways:
    <ol>
    <li>If the user is registered, we log their <i>user_id</i> and
    check if they have voted previously.
    <li>We also cookie the user and check for the presence of the
    cookie in subsequent votes.
    </ol>
<li>You cannot vote on a poll which has expired or is disabled.
However, you can always view the results.
</ul>

<h3>ToDo</h3>
<ul>
<li>Use <i>ad_form</i> instead of the <i>template::form</i>
procedures.
<li>Move all queries to xql files and port to Oracle.
<li>Some work would need to be done to have the poll included in any
page, as well as pop up the results in a separate window, as seems to
be common practice in many sites.  The voting form and results table
would probably need to be separated as "includes".
<li>Improve anti-vote-dumping measures.
<li>Add more detailed reports.
</ul>

</body>
</html>
