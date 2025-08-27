# Lae AD moodul (vajalik, kui pole automaatselt laetud)
Import-Module ActiveDirectory

# Küsi ees- ja perenimi
$eesnimi = Read-Host "Sisesta kasutaja eesnimi"
$perenimi = Read-Host "Sisesta kasutaja perenimi"

# Loo kasutajanimi kujul ees.perenimi
$kasutajanimi = ("{0}.{1}" -f $eesnimi, $perenimi).ToLower()
$taisnimi = "$eesnimi $perenimi"

# Kontrolli, kas kasutaja on juba AD-s olemas
$adkasutaja = Get-ADUser -Filter {SamAccountName -eq $kasutajanimi} -ErrorAction SilentlyContinue

if ($null -ne $adkasutaja) {
    Write-Host "AD kasutaja '$kasutajanimi' on juba olemas."
}
else {
    # Parool
    $parool = ConvertTo-SecureString "Parool1!" -AsPlainText -Force

    Try {
        # Loo uus AD kasutaja
        New-ADUser -SamAccountName $kasutajanimi `
                   -UserPrincipalName "$kasutajanimi@domeen.local" `  # <- muuda oma domeeni järgi!
                   -Name $taisnimi `
                   -GivenName $eesnimi `
                   -Surname $perenimi `
                   -Description "AD kasutaja: $taisnimi" `
                   -AccountPassword $parool `
                   -Enabled $true -ErrorAction Stop

        Write-Host "AD kasutaja '$kasutajanimi' edukalt loodud!"
    }
    Catch {
        Write-Host "AD kasutaja loomine ebaõnnestus."
        Write-Host "Veateade: $($_.Exception.Message)"
    }
}
