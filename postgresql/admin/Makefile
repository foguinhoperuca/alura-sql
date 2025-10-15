.PHONY: db-script

db-admin-script:
		@psql -v forgesys_path="$(shell pwd)" -h $(DB_ADMIN_HOST) -p $(DB_ADMIN_PORT) -d $(DB_ADMIN_DATABASE) -U $(DB_ADMIN_USER) -f $(DB_ADMIN_SCRIPT)

db-script:
	@psql -v forgesys_path="$(shell pwd)" -h $(DB_HOST) -p $(DB_PORT) -d $(DB_DATABASE) -U $(DB_USER) -f $(DB_SCRIPT)

db-pgbench:
	pgbench -i -s 10 pgbench_test
	pgbench -c 10 -t 1000 pgbench_test

db-pgbench-frutally:
	pgbench -h 127.0.0.1 -p 5432 -U postgres -c 50 -T 30 FRUTALLY_VENDAS
	pgbench -h 127.0.0.1 -p 6432 -U postgres -c 50 -T 30 FRUTALLY_VENDAS

db-monitoring-mswindows:
	4010_management_monitoring/alert_time_query.ps1
	4010_management_monitoring/alert_time_query_gmail.ps1
	4010_management_monitoring/check_time_query.ps1

## TODO use project forge
#MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
#
#include $(MAKEFILE_DIR)forge/main.mk
#include $(MAKEFILE_DIR)forge/python.mk
#include $(MAKEFILE_DIR)forge/database.mk
