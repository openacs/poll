ad_page_contract {

    Swap a poll choice with a previous one.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-01-13
} {
    poll_id:naturalnum
    choice_id:naturalnum
}

permission::require_permission -object_id $poll_id -privilege write

db_transaction {
    db_dml incr_prev "update poll_choices set sort_order = sort_order + 1
		      where choice_id = (select choice_id from poll_choices
                                         where sort_order = (select sort_order - 1 from poll_choices where choice_id = :choice_id)
                      and poll_id = :poll_id)"

    db_dml dec_cur "update poll_choices set sort_order = sort_order - 1 where choice_id = :choice_id"
}

ad_returnredirect "poll-ae?poll_id=$poll_id"
