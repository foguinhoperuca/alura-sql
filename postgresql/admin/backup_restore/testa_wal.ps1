# Define o diretório onde os arquivos WAL estão localizados
$wal_dir = "C:\CURSOPOST\CURSO2\WAL"

# Define o caminho para o executável pg_waldump
$pg_waldump_path = "C:\Program Files\PostgreSQL\16\bin\pg_waldump.exe"

# Muda para o diretório de trabalho onde estão os arquivos WAL
Set-Location -Path $wal_dir

# Verifica se o diretório de WALs existe
if (-Not (Test-Path $wal_dir)) {
    Write-Output "O diretório $wal_dir não foi encontrado."
    exit 1
}

# Obtém todos os arquivos no diretório WAL
$wal_files = Get-ChildItem -Path $wal_dir -File

# Verifica se há arquivos WAL no diretório
if ($wal_files.Count -eq 0) {
    Write-Output "Nenhum arquivo WAL encontrado no diretório $wal_dir."
    exit 1
}

# Executa pg_waldump em cada arquivo WAL
foreach ($wal_file in $wal_files) {
    $wal_file_name = $wal_file.Name
    Write-Output "Processando arquivo WAL: $wal_file_name"
    
    # Executa o pg_waldump no arquivo WAL atual usando apenas o nome do arquivo
    & $pg_waldump_path -q $wal_file_name
    if ($LASTEXITCODE -ne 0) {
        Write-Output "Erro ao processar $wal_file_name com pg_waldump."
    } else {
        Write-Output "pg_waldump executado com sucesso para $wal_file_name."
    }
}

Write-Output "Processamento concluído."
