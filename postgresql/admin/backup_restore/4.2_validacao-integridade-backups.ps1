# Restaurar o backup completo em um banco de dados de teste
pg_restore -U seu_usuario -d Frutally_vendas_teste "C:\CursoPost\Curso2\backup\Frutally_vendas_full.backup"

# Comparar o n?mero de registros entre a base original e a base de teste
$countOriginal = psql -U seu_usuario -d Frutally_vendas -c "SELECT COUNT(*) FROM notas_fiscais;"
$countTest = psql -U seu_usuario -d Frutally_vendas_teste -c "SELECT COUNT(*) FROM notas_fiscais;"

if ($countOriginal -eq $countTest) {
    Write-Host "Valida??o bem-sucedida: os dados s?o consistentes."
} else {
    Write-Host "Valida??o falhou: os dados n?o correspondem."
}
