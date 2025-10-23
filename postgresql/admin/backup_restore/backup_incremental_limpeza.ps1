# Defina a senha do PostgreSQL
$env:PGPASSWORD = "postgres"

# Captura a data e hora atual no formato AAAAMMDD e HHMM
$DATE = (Get-Date).ToString("yyyyMMdd")
$TIME = (Get-Date).ToString("HHmm")

# Define o diretório de backup
$BACKUP_DIR = "C:\CURSOPOST\CURSO2\Backup_Inc\$DATE`_$TIME"
New-Item -Path $BACKUP_DIR -ItemType Directory -Force

# Alerta de início do backup
Write-Output "[ALERTA] Iniciando o backup incremental..."
Write-Output ""

# Executa o backup incremental com compressão (-z) e coleta os WALs necessários (-X fetch)
$pg_basebackup_path = "C:\Program Files\PostgreSQL\16\bin\pg_basebackup.exe"
$backup_command = "& `"$pg_basebackup_path`" -U postgres -D `"$BACKUP_DIR`" -Ft -z -X fetch"

Invoke-Expression $backup_command
if ($LASTEXITCODE -ne 0) {
    Write-Output "[ERRO] Ocorreu um problema ao realizar o backup! Verifique os logs."
    [console]::beep(1000, 500)
    Pause
    exit 1
} else {
    Write-Output "[SUCESSO] Backup incremental realizado com sucesso!"
}

# Grava um registro no log com data e hora específicas
$LOG_FILE = "C:\CURSOPOST\CURSO2\Backup_Inc\backup_log_${DATE}_$TIME.txt"
"Backup incremental realizado em $DATE`_$TIME" | Out-File -FilePath $LOG_FILE -Encoding utf8

# Limpa o diretório de arquivos WAL após o backup bem-sucedido
$wal_dir = "C:\CURSOPOST\CURSO2\WAL"

if (Test-Path $wal_dir) {
    Write-Output "[ALERTA] Limpando o conteúdo do diretório de arquivos WAL em $wal_dir..."
    Remove-Item -Path "$wal_dir\*" -Recurse -Force
    Write-Output "[SUCESSO] Conteúdo do diretório WAL limpo com sucesso."
} else {
    Write-Output "[ERRO] Diretório WAL não encontrado."
}

# Alerta de conclusão do backup
Write-Output ""
Write-Output "[ALERTA] Backup concluído. Log registrado em $LOG_FILE."
Write-Output ""
