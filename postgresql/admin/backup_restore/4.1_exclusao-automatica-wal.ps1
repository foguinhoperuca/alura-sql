# Diret?rio dos arquivos WAL
$walDir = "C:\CursoPost\Curso2\val"

# Remover todos os arquivos WAL antes de gerar o backup incremental
Remove-Item "$walDir\*" -Force

# Gerar o backup incremental
pg_basebackup -U seu_usuario -D "C:\CursoPost\Curso2\backup" -Ft -z -Xf
