# Configurar variáveis de ambiente para a conexão com o PostgreSQL
$PGUSER = "postgres"
$PGPASSWORD = "postgres"
$PGDATABASE = "FRUTALLY_VENDAS"
$PGHOST = "localhost"
$PGPORT = 5432
$PostgresVersion = "16"
$Limite = 10

$PSQL_PATH = "C:\Program Files\PostgreSQL\$PostgresVersion\bin\psql.exe"

# Caminho para os arquivos temporários
$TEMP_SQL_FILE = "C:\TEMP\update_queries.sql"

# Garantir que o diretório TEMP existe
if (-not (Test-Path "C:\TEMP")) {
    New-Item -Path "C:\TEMP" -ItemType Directory
}

# Garantir que os arquivos temporários existem
if (-not (Test-Path $TEMP_SQL_FILE)) {
    New-Item -Path $TEMP_SQL_FILE -ItemType File
}

# Limpar arquivos temporários
Clear-Content $TEMP_SQL_FILE

# Log inicial
Write-Output "Iniciando verificação de consultas com tempo limite $Limite segundos"

# Verificar consultas que ultrapassaram o limite
$search_sql = "SELECT * FROM query_logs WHERE duration_s > ($Limite) AND checkquery = 'NOTCHECK';"
$env:PGPASSWORD = $PGPASSWORD
$search_result = & $PSQL_PATH -U $PGUSER -d $PGDATABASE -h $PGHOST -p $PGPORT -c "$search_sql" -At

if ($search_result) {
    $count_sql = "SELECT COUNT(*) FROM query_logs WHERE duration_s > ($Limite) AND checkquery = 'NOTCHECK';"
    $count_result = & $PSQL_PATH -U $PGUSER -d $PGDATABASE -h $PGHOST -p $PGPORT -c "$count_sql" -At
    Write-Output "ALERTA: $count_result consultas ultrapassaram o limite de $Limite segundos."

    # Atualizar campo checkquery para "CHECK"
    $update_sql = "UPDATE query_logs SET checkquery = 'CHECK' WHERE checkquery = 'NOTCHECK';"
    Add-Content $TEMP_SQL_FILE $update_sql

    # Executar comandos SQL gerados
    & $PSQL_PATH -U $PGUSER -d $PGDATABASE -h $PGHOST -p $PGPORT -f $TEMP_SQL_FILE
} else {
    Write-Output "Nenhuma consulta ultrapassou o limite de $Limite segundos."
}

# Log após execução de comandos SQL
Write-Output "Execução de comandos SQL concluída"
