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
} else {
    Write-Output "[ERRO] Ocorreu um problema ao realizar o backup full! Verifique os logs."
    exit 1
}

# Finalização
Write-Output "[ALERTA] Backup completo realizado. Registro salvo em backup_full_log.txt."
