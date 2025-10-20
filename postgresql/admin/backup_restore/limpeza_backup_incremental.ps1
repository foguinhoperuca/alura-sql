# Defina aqui os parâmetros
$dir_raiz = "C:\CURSOPOST\CURSO2\Backup_Inc"
$minutos_parametro = 10

# Obter data e hora atuais
$current_datetime = Get-Date
$current_total_minutes = ($current_datetime.Year * 525600) + ($current_datetime.Month * 43800) + ($current_datetime.Day * 1440) + ($current_datetime.Hour * 60) + $current_datetime.Minute

Write-Output "[DEBUG] Current DateTime: $($current_datetime.ToString('yyyy-MM-dd HH:mm'))"
Write-Output "[DEBUG] current_total_minutes: $current_total_minutes"

# Variável para armazenar o folder mais recente
$most_recent_datetime = $null

# Percorrer cada pasta no diretório raiz
Write-Output "[DEBUG] Percorrendo pastas no diretório raiz: $dir_raiz"
$folders = Get-ChildItem -Path $dir_raiz -Directory | Sort-Object Name

foreach ($folder in $folders) {
	$folder_datetime_str = $folder.Name
	if (-not $most_recent_datetime) {
        $most_recent_datetime = $folder_datetime_str
    }
    elseif ($folder_datetime_str -gt $most_recent_datetime) {
        $most_recent_datetime = $folder_datetime_str
    }
}
Write-Output "[DEBUG] most_recent_datetime: $most_recent_datetime"

foreach ($folder in $folders) {
    $folder_datetime_str = $folder.Name
    Write-Output "[DEBUG] Processando pasta: $folder_datetime_str"

    # Extrair partes da data e hora do nome da pasta
    $folder_year = [int]$folder_datetime_str.Substring(0, 4)
    $folder_month = [int]$folder_datetime_str.Substring(4, 2)
    $folder_day = [int]$folder_datetime_str.Substring(6, 2)
    $folder_hour = [int]$folder_datetime_str.Substring(9, 2)
    $folder_minute = [int]$folder_datetime_str.Substring(11, 2)

    # Converter data e hora da pasta para total de minutos
    $folder_total_minutes = ($folder_year * 525600) + ($folder_month * 43800) + ($folder_day * 1440) + ($folder_hour * 60) + $folder_minute

    # Calcular a diferença em minutos entre a data/hora atual e a da pasta
    $diff_minutes = $current_total_minutes - $folder_total_minutes
	
    $log_file = Join-Path -Path $dir_raiz -ChildPath "backup_log_$folder_datetime_str.txt"
    if ($diff_minutes -gt $minutos_parametro -and $folder_datetime_str -ne $most_recent_datetime) {
        Write-Output "[DEBUG] Apagando a pasta $folder e o arquivo correspondente $log_file"
        Remove-Item -Recurse -Force $folder.FullName
        Remove-Item -Force $log_file
    }
    else {
        Write-Output "[DEBUG] Mantendo a pasta $folder e o arquivo correspondente $log_file"
    }
}

Write-Output "[DEBUG] Script concluído."
