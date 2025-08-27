# Määrame varukoopiate sihtkausta
$backupPath = "C:\Backup"

# Kui kausta ei ole, siis loome
if (-not (Test-Path $backupPath)) {
    New-Item -ItemType Directory -Path $backupPath | Out-Null
}

# Täna kuupäev varukoopia failinimesse
$kuupaev = Get-Date -Format "dd.MM.yyyy"

# Vaatame kõik kasutajate kodukaustad (C:\Users)
$kasutajad = Get-ChildItem "C:\Users" -Directory | Where-Object {
    # Välistame süsteemikontod
    $_.Name -notin @("Administrator", "Default", "Default User", "Public", "All Users")
}

foreach ($kasutaja in $kasutajad) {
    $kasutajanimi = $kasutaja.Name
    $lahteKaust = $kasutaja.FullName
    $zipFail = Join-Path $backupPath "$kasutajanimi-$kuupaev.zip"

    Write-Host "Varundan kasutajat: $kasutajanimi ..."

    Try {
        # Kui fail juba olemas, kustutame vana
        if (Test-Path $zipFail) {
            Remove-Item $zipFail -Force
        }

        # Pakkimine ZIP faili
        Compress-Archive -Path $lahteKaust -DestinationPath $zipFail -Force

        if (Test-Path $zipFail) {
            Write-Host "Varukoopia loodud: $zipFail"
        }
    }
    Catch {
        Write-Host "Kasutaja $kasutajanimi varundamine ebaõnnestus!"
        Write-Host "Veateade: $($_.Exception.Message)"
    }
}
