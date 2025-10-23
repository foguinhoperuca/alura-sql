# Verificar a integridade dos arquivos WAL
$walFiles = Get-ChildItem -Path "C:\CursoPost\Curso2\val" -Filter "*.wal"
foreach ($file in $walFiles) {
    pg_waldump -q $file.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erro na verifica??o do arquivo WAL: $($file.Name)"
    } else {
        Write-Host "Arquivo WAL verificado com sucesso: $($file.Name)"
    }
}
