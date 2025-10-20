# Defina a senha do PostgreSQL
$env:PGPASSWORD = "postgres"

# Captura a data e hora atual no formato AAAAMMDD e HHMM
$DATE = (Get-Date).ToString("yyyyMMdd")
$TIME = (Get-Date).ToString("HHmm")

# Define o diretório de backup
$BACKUP_DIR = "C:\CURSOPOST\CURSO2\backup_inc\$DATE`_$TIME"
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
$LOG_FILE = "C:\CURSOPOST\CURSO2\backup_inc\backup_log_${DATE}_$TIME.txt"
"Backup incremental realizado em $DATE`_$TIME" | Out-File -FilePath $LOG_FILE -Encoding utf8

# Alerta de conclusão do backup
Write-Output ""
Write-Output "[ALERTA] Backup concluido. Log registrado em $LOG_FILE."
Write-Output ""
