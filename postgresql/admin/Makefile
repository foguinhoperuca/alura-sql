.PHONY: db-script

db-get-extra-content:
	# postgresql-administracao-monitoramento.01.05
	wget https://cdn3.gnarususercontent.com.br/4010-postgreSQL/4010%20-%20Video%201.3%20Download.zip

	# postgresql-administracao-monitoramento.02.06
	wget https://cdn3.gnarususercontent.com.br/4010-postgreSQL/4010%20-%20Video%202.3%20Download.zip

	# postgresql-administracao-monitoramento.04.05
	wget https://cdn3.gnarususercontent.com.br/4010-postgreSQL/4010%20-%20Video%204.3%20Download.zip

	# postgresql-administracao-monitoramento.04.08
	wget https://cdn3.gnarususercontent.com.br/4010-postgreSQL/4010%20-%20Video%204.4%20Download.zip

	# postgresql-administracao-monitoramento.05.03
	wget https://cdn3.gnarususercontent.com.br/4010-postgreSQL/4010%20-%20Video%205.2%20Download.zip

	# administracao-postgresql-backup-recuperacao.02.01
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.1%20-%20Download.zip

	# administracao-postgresql-backup-recuperacao.02.04
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.2%20-%20Download.zip

	# administracao-postgresql-backup-recuperacao.02.08
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.3%20-%20Download.zip

	# administracao-postgresql-backup-recuperacao.02.12
	wget https://cdn3.gnarususercontent.com.br/4011-postgresql/Projeto%20-%20Arquivos%20para%20download/4011%20-%20Video%202.4%20-%20Download.zip

	# administracao-postgresql-desempenho-otimizacao.01.02
	wget https://cdn3.gnarususercontent.com.br/4012-postgresql/Projeto%20-%20Download/4012%20-%20Preparando%20o%20ambiente%20-%20Modificando%20a%20base%20de%20dados%20Frutally%20Vendas/4012%20-%20Preparando%20o%20ambiente%20-%20Modificando%20a%20base%20de%20dados%20Frutally%20Vendas.zip

	# administracao-postgresql-desempenho-otimizacao.01.03
	wget https://cdn3.gnarususercontent.com.br/4012-postgresql/Projeto%20-%20Download/4012%20-%20Preparando%20o%20ambiente%20-%20Scripts%20do%20curso/4012%20-%20Preparando%20o%20ambiente%20-%20Scripts%20do%20curso.zip

	# administracao-postgresq-replicacao-alta-disponibilidade.01.02
	wget https://cdn3.gnarususercontent.com.br/4013-administracao-postgresql/Projeto%20-%20Downloads/4013%20-%20V%C3%ADdeo%201.0A%20-%20Preparando%20a%20base%20de%20dados/4013%20-%20V%C3%ADdeo%201.0A%20-%20Preparando%20a%20base%20de%20dados.zip

	# administracao-postgresq-replicacao-alta-disponibilidade.01.03
	Wget https://cdn3.gnarususercontent.com.br/4013-administracao-postgresql/Projeto%20-%20Downloads/4013%20-%20Video%201.0B%20-%20Acessando%20os%20scripts%20do%20curso/4013%20-%20Video%201.0B%20-%20Acessando%20os%20scripts%20do%20curso.zip

db-pgbench:
	pgbench -i -s 10 pgbench_test
	pgbench -c 10 -t 1000 pgbench_test

db-pgbench-frutally:
	pgbench -h 127.0.0.1 -p 5432 -U postgres -c 50 -T 30 FRUTALLY_VENDAS
	pgbench -h 127.0.0.1 -p 6432 -U postgres -c 50 -T 30 FRUTALLY_VENDAS

db-pgbasebackup: BACKUP_DIR=/tmp/pg/backup/
db-pgbasebackup:
	pg_basebackup -U $(DB_ADMIN_USER) -D $(BACKUP_DIR) -Ft -z -X fetch

db-pgrestore: BACKUP_FILE=/tmp/pg/backup/restore_me.bkp
db-pgrestore:
	pg_restore --clean --if-exists -U $(DB_ADMIN_USER) -d $(DB_ADMIN_DATABASE) $(BACKUP_FILE)

db-monitoring-mswindows:
	4010_management_monitoring/alert_time_query.ps1
	4010_management_monitoring/alert_time_query_gmail.ps1
	4010_management_monitoring/check_time_query.ps1

db-backup-mswindows:
	backup_restore/backup_incremental.ps1

db-pgwalldump:
	pg_waldump -q $(WAL_FILENAME)

db-backup-to-slave:
	pg_basebackup -D '/var/data/postgresql/alura/slave' -Fp -Xs _P -R -h localhost -U alura
	pg_ctl register -N "postgresql-slave" -D /var/data/postgresql/alura/slave

MAKEFILE_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

include $(MAKEFILE_DIR)/forge/main.mk
include $(MAKEFILE_DIR)/forge/python.mk
include $(MAKEFILE_DIR)/forge/database.mk
include $(MAKEFILE_DIR)/forge/geo.mk
