# log files
vivian_logs="${vivian_root}/logs"
vivian_logs_general="${vivian_logs}/general.log"
vivian_logs_mon="${vivian_logs}/last_backup"
vivian_logs_localbkp="${vivian_logs}/localbkp"

# monitoring logs
vivian_mon_status_ok="echo WE_HAVE_FRESH_BACKUP"
vivian_mon_status_error="echo TODAY_ARCHIVE_EXISTS"
vivian_mon_status_localbkp_error="echo LOCALBKP_IS_NOT_EMPTY"
vivian_mon_status_localbkp_ok="echo LOCALBKP_IS_EMPTY"

function log() {

	# small function for logging

	echo "[`date +"%d.%m.%Y %T"`] $1" >> $vivian_logs_general

}

function send_mail() {
	if [ -z "$monitoring_email" ]; then return; fi
	subject=$1
	content=$2
	echo $content | mail -a "Content-Type: text/plain; charset=UTF-8" -s $subject $monitoring_email
}

function vivian_clear_logs() {

	# this function will clear vivian logs
	# and monitoring checks.

	# clear general log file
	cat /dev/null > $vivian_logs_general
	log "The log file was cleared."
}

function localbkp_check() {

	# this function will cleck if localbkp is empty
	if find "$vivian_localbkp" -mindepth 1 -print -quit | grep -q .;

	then

		$vivian_mon_status_localbkp_error > $vivian_logs_localbkp

	else

		$vivian_mon_status_localbkp_ok > $vivian_logs_localbkp

	fi

}
