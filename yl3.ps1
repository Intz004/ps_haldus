# Küsi kasutajalt ees- ja perenimi
$eesnimi = Read-Host "Sisesta oma eesnimi (ainult ladina tähed)"
$perenimi = Read-Host "Sisesta oma perenimi (ainult ladina tähed)"

# Loo kasutajanimi kujul ees.perenimi ja teisenda väiketähtedeks
$kasutajanimi = ("{0}.{1}" -f $eesnimi, $perenimi).ToLower()
$taisnimi = "$eesnimi $perenimi"
$kirjeldus = "Kohalik kasutaja: $taisnimi"

Write-Host "Loodav kasutaja: $kasutajanimi"
Write-Host "Täisnimi: $taisnimi"
Write-Host "Kirjeldus: $kirjeldus"

# Kontrolli, kas kasutaja juba eksisteerib
$olemasolev = Get-LocalUser -Name $kasutajanimi -ErrorAction SilentlyContinue

if ($null -ne $olemasolev) {
    Write-Host "Kasutaja '$kasutajanimi' on süsteemis juba olemas. Loomist ei toimu."
}
else {
    # Määra vaikeparool
    $parool = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

    Try {
        # Proovi luua uus kasutaja
        New-LocalUser -Name $kasutajanimi -Password $parool -FullName $taisnimi -Description $kirjeldus -ErrorAction Stop
        if ($?) {
            Write-Host "Kasutaja '$kasutajanimi' on edukalt loodud!"
        }
    }
    Catch {
        Write-Host "Kasutaja loomine ebaõnnestus."
        Write-Host "Veateade: $($_.Exception.Message)"
    }
}
