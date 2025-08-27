# Lae AD moodul (vajalik, kui pole automaatselt laetud)
Import-Module ActiveDirectory

# Funktsioon parooli genereerimiseks
function Genereeri-Parool {
    param (
        [int]$Pikkus = 12
    )
    Add-Type -AssemblyName System.Web
    # Genereerib tugeva parooli, milles on suured/väikesed tähed, numbrid ja sümbolid
    return [System.Web.Security.Membership]::GeneratePassword($Pikkus,2)
}

# Küsi ees- ja perenimi
$eesnimi = Read-Host "Sisesta kasutaja eesnimi"
$perenimi = Read-Host "Sisesta kasutaja perenimi"

# Loo kasutajanimi kujul ees.perenimi
$kasutajanimi = ("{0}.{1}" -f $eesnimi, $perenimi).ToLower()
$taisnimi = "$eesnimi $perenimi"

# Kontrolli, kas kasutaja on juba olemas AD-s
$adkasutaja = Get-ADUser -Filter {SamAccountName -eq $kasutajanimi} -ErrorAction SilentlyContinue

if ($null -ne $adkasutaja) {
    Write-Host "AD kasutaja '$kasutajanimi' on juba olemas."
}
else {
    # Genereeri parool
    $paroolPlain = Genereeri-Parool -Pikkus 14
    $parool = ConvertTo-SecureString $paroolPlain -AsPlainText -Force

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

        Write-Host "AD kasutaja '$kasutajanimi' on edukalt loodud!"

        # Salvesta kasutaja ja parool CSV faili
        $exportData = [PSCustomObject]@{
            Kasutajanimi = $kasutajanimi
            Parool       = $paroolPlain
        }
        $exportData | Export-Csv -Path "$kasutajanimi.csv" -NoTypeInformation -Encoding UTF8
        Write-Host "Kasutaja andmed salvestatud faili: $kasutajanimi.csv"
    }
    Catch {
        Write-Host "AD kasutaja loomine ebaõnnestus."
        Write-Host "Veateade: $($_.Exception.Message)"
    }
}
