ad_page_contract {

    Displays active polls on the site.

    @author Robert Locke (rlocke@infiniteinfo.com)
    @creation-date 2003-01-12
    
   
} {
}

set package_id [ad_conn package_id]
set user_id    [ad_conn user_id]

# Check if the user has the proper rights.
set create_p [permission::permission_p -object_id $package_id -privilege create]

#
# List all the polls.
#
set archive_label_set 0
set disabled_label_set 0

db_multirow -extend {archive_label_p disabled_label_p name_js} polls polls_select {} {
    set archive_label_p 0
    set disabled_label_p 0

    # Don't show disabled polls unless the user has
    # edit or delete privileges.
    if { !$enabled_p && !$edit_p && !$delete_p } {
	continue
    }

    # Show the archive label if it hasn't been shown yet.
    if { !$active_p && !$archive_label_set && $enabled_p } {
	set archive_label_p 1
	set archive_label_set 1
    }

    # Show the disabled label if it hasn't been shown yet.
    if { !$enabled_p && !$disabled_label_set } {
	set disabled_label_p 1
	set disabled_label_set 1
    }

    regsub -all {'} $name {\'} name_js
}
