# Lae AD moodul (vajalik, kui pole automaatselt laetud)
Import-Module ActiveDirectory

# Küsi ees- ja perenimi
$eesnimi = Read-Host "Sisesta kustutatava kasutaja eesnimi"
$perenimi = Read-Host "Sisesta kustutatava kasutaja perenimi"

# Loo kasutajanimi kujul ees.perenimi
$kasutajanimi = ("{0}.{1}" -f $eesnimi, $perenimi).ToLower()

Write-Host "Kontrollin AD kasutajat: $kasutajanimi ..."

# Kontrolli, kas kasutaja eksisteerib AD-s
$adkasutaja = Get-ADUser -Filter {SamAccountName -eq $kasutajanimi} -ErrorAction SilentlyContinue

if ($null -eq $adkasutaja) {
    Write-Host "AD kasutajat '$kasutajanimi' ei leitud."
}
else {
    Try {
        # Kustuta kasutaja
        Remove-ADUser -Identity $adkasutaja -Confirm:$false -ErrorAction Stop
        Write-Host "AD kasutaja '$kasutajanimi' on edukalt kustutatud."
    }
    Catch {
        Write-Host "AD kasutaja kustutamine ebaõnnestus."
        Write-Host "Veateade: $($_.Exception.Message)"
    }
}
