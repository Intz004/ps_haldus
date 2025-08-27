# Küsi kasutajalt ees- ja perenimi
$eesnimi = Read-Host "Sisesta kustutatava kasutaja eesnimi"
$perenimi = Read-Host "Sisesta kustutatava kasutaja perenimi"

# Loo kasutajanimi kujul ees.perenimi (väiketähtedega)
$kasutajanimi = ("{0}.{1}" -f $eesnimi, $perenimi).ToLower()

Write-Host "Kustutatav kasutaja on $kasutajanimi"

# Kontrolli, kas kasutaja eksisteerib
$kasutaja = Get-LocalUser -Name $kasutajanimi -ErrorAction SilentlyContinue

if ($null -eq $kasutaja) {
    Write-Host "Kasutajat '$kasutajanimi' ei leitud süsteemist."
}
else {
    Try {
        Remove-LocalUser -Name $kasutajanimi -ErrorAction Stop
        if ($?) {
            Write-Host "Kasutaja '$kasutajanimi' on edukalt kustutatud."
        }
    }
    Catch {
        Write-Host "Kasutaja kustutamine ebaõnnestus."
        Write-Host "Veateade: $($_.Exception.Message)"
    }
}
