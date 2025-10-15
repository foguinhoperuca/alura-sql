# Configurar variáveis de ambiente para a conexão com o PostgreSQL
$PGUSER = "postgres"
$PGPASSWORD = "postgres"
$PGDATABASE = "FRUTALLY_VENDAS"
$PGHOST = "localhost"
$PGPORT = 5432
$PostgresVersion = "16"

$PSQL_PATH = "C:\Program Files\PostgreSQL\$PostgresVersion\bin\psql.exe"

# Comando para obter a lista de tabelas no esquema public
$table_query = @"
SELECT tablename 
FROM pg_tables 
WHERE schemaname = 'public';
"@

# Executar o comando e capturar a saída
$env:PGPASSWORD = $PGPASSWORD
$table_list = & $PSQL_PATH -U $PGUSER -d $PGDATABASE -h $PGHOST -p $PGPORT -c "$table_query" -At

# Inicializar o comando vacuum_analyze
$vacuum_analyze_commands = ""

# Iterar sobre a lista de tabelas e gerar os comandos VACUUM ANALYZE
foreach ($table in $table_list) {
    $command = "VACUUM ANALYZE $table;"
    Write-Output "Executando comando: $command"
    $vacuum_analyze_commands += "$command`n"
}

# Escrever os comandos VACUUM ANALYZE em um arquivo SQL temporário
$temp_sql_file = "C:\TEMP\vacuum_analyze_all.sql"
Set-Content -Path $temp_sql_file -Value $vacuum_analyze_commands

# Executar os comandos VACUUM ANALYZE usando psql
& $PSQL_PATH -U $PGUSER -d $PGDATABASE -h $PGHOST -p $PGPORT -f $temp_sql_file

# Limpar a variável de senha
$env:PGPASSWORD = ""

# Remover o arquivo temporário
Remove-Item -Path $temp_sql_file
