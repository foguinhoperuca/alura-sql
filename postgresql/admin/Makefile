.PHONY: db-script

db-get-extra-content:
	# administracao-postgresql-backup-recuperacao.02.01
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.1%20-%20Download.zip

	# administracao-postgresql-backup-recuperacao.02.04
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.2%20-%20Download.zip

	# administracao-postgresql-backup-recuperacao.02.08
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.3%20-%20Download.zip

	# administracao-postgresql-backup-recuperacao.02.12
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.4%20-%20Download.zip

db-pgbench:
	pgbench -i -s 10 pgbench_test
	pgbench -c 10 -t 1000 pgbench_test

db-pgbench-frutally:
	pgbench -h 127.0.0.1 -p 5432 -U postgres -c 50 -T 30 FRUTALLY_VENDAS
	pgbench -h 127.0.0.1 -p 6432 -U postgres -c 50 -T 30 FRUTALLY_VENDAS

db-pgbasebackup: BACKUP_DIR=/tmp/pg/backup/
db-pgbasebackup:
	pg_basebackup -U $(DB_ADMIN_USER) -D $(BACKUP_DIR) -Ft -z -X fetch

db-monitoring-mswindows:
	4010_management_monitoring/alert_time_query.ps1
	4010_management_monitoring/alert_time_query_gmail.ps1
	4010_management_monitoring/check_time_query.ps1

db-backup-mswindows:
	backup_restore/backup_incremental.ps1

MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEFILE_DIR)../../forge/main.mk
include $(MAKEFILE_DIR)../../forge/python.mk
include $(MAKEFILE_DIR)../../forge/database.mk
include $(MAKEFILE_DIR)../../forge/geo.mk
