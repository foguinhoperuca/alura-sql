# Configuração da senha do PostgreSQL
$env:PGPASSWORD = "postgres"

# Captura a data e hora atual no formato AAAAMMDD_HHMM
$DATE = (Get-Date).ToString("yyyyMMdd_HHmm")

# Define o diretório de backup full
$BACKUP_DIR = "C:\CURSOPOST\CURSO2\Backup"

# Cria o diretório de backup full se não existir
if (-not (Test-Path -Path $BACKUP_DIR)) {
    New-Item -Path $BACKUP_DIR -ItemType Directory -Force
}

# Nome do arquivo de backup com timestamp
$BACKUP_FILE = "$BACKUP_DIR\FRUTALLY_VENDAS_full_$DATE.bak"

# Comando para realizar o backup full, especificando o caminho completo para o pg_dump
$pg_dump_command = "& 'C:\Program Files\PostgreSQL\16\bin\pg_dump.exe' -U postgres -d FRUTALLY_VENDAS -F c -f `"$BACKUP_FILE`""

# Executa o backup full
Invoke-Expression $pg_dump_command

# Verifica se o comando anterior foi bem-sucedido
if ($LASTEXITCODE -eq 0) {
    Write-Output "Backup completo realizado em $DATE" >> "$BACKUP_DIR\backup_full_log.txt"
    Write-Output "[SUCESSO] Backup full realizado com sucesso!"

    # Restaura o backup no banco FRUTALLY_VENDAS_TESTE
    $pg_restore_command = "& 'C:\Program Files\PostgreSQL\16\bin\pg_restore.exe' -U postgres -d FRUTALLY_VENDAS_TESTE --clean --if-exists `"$BACKUP_FILE`""
    Invoke-Expression $pg_restore_command

    if ($LASTEXITCODE -eq 0) {
        Write-Output "[SUCESSO] Backup restaurado com sucesso no banco FRUTALLY_VENDAS_TESTE."
        
        # Verifica a integridade do backup comparando as contagens das tabelas
        $query_vendas = "SELECT COUNT(*) FROM notas_fiscais;"
        
        $count_vendas = & "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -d FRUTALLY_VENDAS -t -c "$query_vendas"
        $count_vendas_teste = & "C:\Program Files\PostgreSQL\16\bin\psql.exe" -U postgres -d FRUTALLY_VENDAS_TESTE -t -c "$query_vendas"

        # Captura o primeiro valor retornado, remove espaços em branco e converte para inteiro
        $count_vendas = [int]($count_vendas.Trim() -split "`n")[0]
        $count_vendas_teste = [int]($count_vendas_teste.Trim() -split "`n")[0]

        # Exibe os valores das contagens na saída
        Write-Output "Contagem de registros em FRUTALLY_VENDAS: $count_vendas"
        Write-Output "Contagem de registros em FRUTALLY_VENDAS_TESTE: $count_vendas_teste"

        if ($count_vendas -eq $count_vendas_teste) {
            Write-Output "[SUCESSO] O backup está íntegro. Contagem de registros igual em ambas as bases de dados."
        } else {
            Write-Output "[ERRO] O backup não está íntegro. Contagem de registros diferente entre as bases de dados."
        }
    } else {
        Write-Output "[ERRO] Ocorreu um problema ao restaurar o backup no banco FRUTALLY_VENDAS_TESTE! Verifique os logs."
        exit 1
    }
} else {
    Write-Output "[ERRO] Ocorreu um problema ao realizar o backup full! Verifique os logs."
    exit 1
}

# Finalização
Write-Output "[ALERTA] Backup completo realizado. Registro salvo em backup_full_log.txt."
