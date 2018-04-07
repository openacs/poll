ad_page_contract {

    Delete a poll choice.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-01-13
} {
    poll_id:naturalnum
    choice_id:naturalnum
}

permission::require_permission -object_id $poll_id -privilege write

db_transaction {
    db_dml dec_sort "update poll_choices set sort_order = sort_order - 1
		     where sort_order > (select sort_order from poll_choices where choice_id = :choice_id)
                     and poll_id = :poll_id"

    db_dml del_poll_choice "delete from poll_choices where choice_id = :choice_id"
}

ad_returnredirect "poll-ae?poll_id=$poll_id"
