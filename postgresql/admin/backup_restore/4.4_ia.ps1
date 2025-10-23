foreach ($file in $walFiles) {
    if ($file.Extension -ne ".wal") {
        Write-Host "Ignorando arquivo com extens?o: $($file.Name)"
        continue
    }
    pg_waldump -q $file.FullName
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Erro na verifica??o do arquivo WAL: $($file.Name)"
    } else {
        Write-Host "Arquivo WAL verificado com sucesso: $($file.Name)"
    }
}
