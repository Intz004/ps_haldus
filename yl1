# Küsi kasutajalt ees- ja perenimi
$eesnimi = Read-Host "Sisesta oma eesnimi (ainult ladina tähed)"
$perenimi = Read-Host "Sisesta oma perenimi (ainult ladina tähed)"

# Teisenda väikesteks tähtedeks ja loo kasutajanimi vormis ees.perenimi
$kasutajanimi = ("{0}.{1}" -f $eesnimi, $perenimi).ToLower()
$taisnimi = "$eesnimi $perenimi"
$kirjeldus = "Kohalik kasutaja: $taisnimi"

Write-Host "Loodav kasutaja: $kasutajanimi"
Write-Host "Täisnimi: $taisnimi"
Write-Host "Kirjeldus: $kirjeldus"

# Määra vaikeparool
$parool = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

# Proovi luua kasutaja
Try {
    New-LocalUser -Name $kasutajanimi -Password $parool -FullName $taisnimi -Description $kirjeldus -ErrorAction Stop
    if ($?) {
        Write-Host "Kasutaja '$kasutajanimi' on edukalt loodud!"
    }
}
Catch {
    Write-Host "Kasutaja loomine ebaõnnestus."
    Write-Host "Veateade: $($_.Exception.Message)"
}
