# Get Docker Hub API response
$response = Invoke-RestMethod -Uri "https://hub.docker.com/v2/repositories/n8nio/n8n/tags/?page_size=20"

# Display latest tag information
Write-Host "=== LATEST TAG ===" -ForegroundColor Green
$latest = $response.results | Where-Object { $_.name -eq 'latest' }
Write-Host "Latest tag updated: $($latest.last_updated)" -ForegroundColor Yellow

# Display recent versions
Write-Host "`n=== RECENT VERSIONS ===" -ForegroundColor Green
$versions = $response.results | Where-Object { $_.name -match '^\d+\.\d+\.\d+$' } | Sort-Object { [DateTime]$_.last_updated } -Descending | Select-Object -First 5
$versions | ForEach-Object { Write-Host "$($_.name) - Updated: $($_.last_updated)" }