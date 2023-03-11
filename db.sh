is_function_loaded log || source logging.sh
is_function_loaded make_sure_dir_exits || source file.sh

dump_mysql_databases() {
	# list all databases. exclude some meta ones
	local skipped="Database|information_schema|mysql|performance_schema|sys|phpmyadmin"
	if [[ -n $skipped_databases ]]; then
		skipped=$skipped"|"${skipped_databases// /|}
	fi
	local connection="--user=${mysql_config[username]-} --password=${mysql_config[password]-} --host=${mysql_config[host]-} --port=${mysql_config[port]-}"
	local databases=$(mysql $connection -e "SHOW DATABASES" | grep -E -v "^(${skipped})$")
	local storage_dir=$1
	local current_date=$(date +%Y%m%d-%H%M)
	for db in $databases; do
		log "Dumping database: $db"
		local db_dir="$storage_dir/$db"
		make_sure_dir_exits "$db_dir"
		mysqldump $connection $db | gzip > "$db_dir/$db-$current_date.sql.gz"
	done
}

dump_pg_databases() {
	local storage_dir=$1
	make_sure_dir_exits "$storage_dir/pg"
	# execute the dump command as user "postgres"
	# following should be in the config for sudo:
	#     vivian ALL=(postgres) NOPASSWD: /usr/bin/pg_dumpall
	sudo -u postgres pg_dumpall 2>/dev/null | gzip > "$storage_dir/pg/pg_all.psql.gz"
}
