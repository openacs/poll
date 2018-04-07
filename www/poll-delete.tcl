ad_page_contract {

    Delete a poll.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-01-13
} {
    poll_id:naturalnum
}


permission::require_permission -object_id $poll_id -privilege delete

db_exec_plsql del_poll " "

ad_returnredirect index
