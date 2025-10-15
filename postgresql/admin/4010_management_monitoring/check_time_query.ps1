# Inicializar variáveis
$StatementKeyword = "instrução:"
$DurationKeyword = "duração:"
$PostgresVersion = "16"
$TableName = "query_logs"

# Configurar variáveis de ambiente para a conexão com o PostgreSQL
$PGUSER = "postgres"
$PGPASSWORD = "postgres"
$PGDATABASE = "FRUTALLY_VENDAS"
$PGHOST = "localhost"
$PGPORT = "5432"

# Caminho para o executável psql
$PSQL_PATH = "C:\Program Files\PostgreSQL\$PostgresVersion\bin\psql.exe"

# Diretório de logs do PostgreSQL
$LOG_DIR = "C:\TEMP\pg_log"

# Caminho para os arquivos temporários
$TEMP_SQL_FILE = "C:\TEMP\insert_queries.sql"

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
Write-Output "Iniciando análise de logs."

# Variáveis temporárias
$accumulating_query = $false
$statement_line = ""
$query = ""
$duration_line = ""

# Função para processar um statement
function Process-Statement {
    param (
        [string]$statement_line,
        [string]$query,
        [string]$duration_line,
        [string]$TableName
    )

    # Extrair informações e gerar comando SQL
    $datetime = $duration_line -replace " LOG:.*", ""
    $datetime = $datetime -replace " CEST.*", ""
    $duration = $duration_line -replace ".*$DurationKeyword\s*", "" -replace " ms", ""
    $query = $query.Trim()

    if ($datetime -ne "" -and $duration -ne "" -and $query -ne "" -and ($query -notmatch $TableName)) {
        $query = $query -replace "'", "''"

        # Verificar se a consulta já foi incluída na tabela query_logs
        $check_sql = "SELECT COUNT(*) FROM $TableName WHERE log_time = '$datetime' AND duration_s = $duration AND query = '$query';"
        $env:PGPASSWORD = $PGPASSWORD
        $check_result = & $PSQL_PATH -U $PGUSER -d $PGDATABASE -h $PGHOST -p $PGPORT -c "$check_sql" -At

        Write-Output "Resultado da verificação: $check_result"

        if ($check_result -eq "0") {
            $sql = "INSERT INTO $TableName (log_time, duration_s, query, checkquery) VALUES ('$datetime', $duration, '$query', 'NOTCHECK');"
            Add-Content $TEMP_SQL_FILE $sql
        } else {
            Write-Output "Query já incluída na tabela"
        }
    } elseif ($query -match $TableName) {
        Write-Output "Consulta descartada por referenciar a tabela."
    } else {
        Write-Output "Erro: Valores inválidos detectados"
    }
}

# Processar todos os arquivos .log no diretório de logs
Get-ChildItem -Path $LOG_DIR -Filter *.log | ForEach-Object {
    $logfile = $_.FullName
    Write-Output "Processando arquivo de log: $logfile"

    # Ler o arquivo de log linha por linha
    $lines = Get-Content $logfile
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]

        # Verificar se a linha contém "statement:"
        if ($line -match $StatementKeyword) {
            # Se há um statement anterior não processado
            if ($accumulating_query -eq $true -and $statement_line -ne "" -and $query -ne "") {
                Process-Statement -statement_line $statement_line -query $query -duration_line $duration_line -TableName $TableName
            }

            $statement_line = $line
            $accumulating_query = $true
            $query = ""

            # Verificar se a consulta começa na mesma linha
            $query_part = $line -replace ".*$StatementKeyword\s*", ""
            if ($query_part -ne "") {
                $query = $query_part
            }

            Write-Output "Encontrado statement"
        } elseif ($accumulating_query -eq $true) {
            # Acumular linhas enquanto "accumulating_query" é verdadeiro
            if ($line -notmatch $DurationKeyword) {
                $query += " " + $line.Trim()
            } else {
                # Verificar se a linha contém "duration:"
                $duration_line = $line
                Write-Output "Encontrado duration"
                if ($statement_line -ne "" -and $query -ne "" -and $duration_line -ne "") {
                    Process-Statement -statement_line $statement_line -query $query -duration_line $duration_line -TableName $TableName
                    $statement_line = ""
                    $query = ""
                    $duration_line = ""
                    $accumulating_query = $false
                }
            }
        }
    }

    # Processar o último statement se não foi finalizado com uma linha "duration:"
    if ($accumulating_query -eq $true -and $statement_line -ne "" -and $query -ne "") {
        Process-Statement -statement_line $statement_line -query $query -duration_line $duration_line -TableName $TableName
    }
}

# Log após filtragem
Write-Output "Filtragem de logs concluída"

# Verificar se o executável psql existe
if (Test-Path $PSQL_PATH) {
    # Executar comandos SQL gerados
    $env:PGPASSWORD = $PGPASSWORD
    & $PSQL_PATH -U $PGUSER -d $PGDATABASE -h $PGHOST -p $PGPORT -f $TEMP_SQL_FILE
} else {
    Write-Output "Erro: Caminho para psql.exe não encontrado"
}

# Log após execução de comandos SQL
Write-Output "Execução de comandos SQL concluída"
