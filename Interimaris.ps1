#Smartschool connectiegegevens
#Lees hier welke gegevens je nodig hebt: https://tsaam.smartschool.be/index.php?module=Manual&file=manual&layout=2&id=handleiding:algemene_configuratie:smartschool-api
$url = "https://naamvandeschool.smartschool.be/Webservices/V3?wsdl"
$Smartschoolwachtwoord = 'WebserviceWachtwoord'
$webservicex = New-WebServiceProxy -Uri $url

#Errocodes ophalen en in Hashtable steken
$errorcodes = $webservicex.returncsvErrorCodes()
$errorcodes = $errorcodes.replace(';"','=')
$errorcodes = $errorcodes.replace('";','')
$hashtable = ConvertFrom-StringData -StringData $errorcodes


#Maakt een nieuwe leerkracht aan en steekt deze in de groep 'Interimarissen'
function SmSUser{
    param([string]$Email,[string]$Wachtwoord,[string]$Voornaam,[string]$Naam)

    write-host "SmS account aanmaken"

    #Webservice wachtwoord, intern nummer, username, wachtwoord ...
    #Zie handleiding voor volledige uitleg van alle parameters.
    $result = $webservicex.saveUser($Smartschoolwachtwoord, $Email,$Email,$Wachtwoord,'','',$Voornaam,$Naam,'','','','','','','','','','','','','','','','','leerkracht','')
    if($hashtable["$result"]){
        Write-Host "Bewerking mislukt: "
        Write-host $hashtable["$result"]
    }
    else{
        write-host "Bewerking gelukt"
    }
    #Nieuw aangemaakt account verplaatsen naar de groep 'Interimarissen'.
    $result = $webservicex.saveUserToClassesAndGroups($Smartschoolwachtwoord, $Email,'Interimarissen','0')
    if($hashtable["$result"]){
        Write-Host "Bewerking mislukt: "
        Write-host $hashtable["$result"]
    }
    else{
        write-host "Bewerking gelukt"
    }
}

#Maakt een co-account van het type 'Interimaris' bij het hoofdaccount van de te vervangen leerkracht
function SmSCoAcc{
    param([string]$HoofdAccount, [string]$Wachtwoord,[string]$Voornaam,[string]$Naam)

    write-host "SmS co-account aanmaken"

    #Gegevens te vervangen leerkracht ophalen
    $result = $webservicex.getUserDetailsByUsername($Smartschoolwachtwoord, $HoofdAccount)
    if($hashtable["$result"]){
        Write-Host "Ophalen gegevens mislukt: "
        Write-host $hashtable["$result"]
    }
    else{
        write-host "Ophalen gegevens gelukt"
        $json = ($result | convertfrom-json)
    }
    #Kijken welke co-accounts nog vrij zijn
    $first = 6
    for($i = 0;$i -lt 7;$i++){
        if(($json."type_coaccount$i" -eq "0") -and ($i -lt $first)){
            $first = $i
        }
    }
    Write-host "Eerste vrije co-account: $first"

    #Nieuw co-account aanmaken, met gegevens van de interimariss
    $result = $webservicex.saveUserParameter($Smartschoolwachtwoord, $json.internnummer, "type_coaccount$first", "Interimaris")
    if($hashtable["$result"]){
        Write-Host "Bewerking mislukt: "
        Write-host $hashtable["$result"]
    }
    else{
        write-host "Bewerking gelukt"
    }
    $result = $webservicex.saveUserParameter($Smartschoolwachtwoord, $json.internnummer, "voornaam_coaccount$first", $Voornaam)
    if($hashtable["$result"]){
        Write-Host "Bewerking mislukt: "
        Write-host $hashtable["$result"]
    }
    else{
        write-host "Bewerking gelukt"
    }
    $result = $webservicex.saveUserParameter($Smartschoolwachtwoord, $json.internnummer, "naam_coaccount$first", $naam)
    if($hashtable["$result"]){
        Write-Host "Bewerking mislukt: "
        Write-host $hashtable["$result"]
    }
    else{
        write-host "Bewerking gelukt"
    }
    $result = $webservicex.savePassword($Smartschoolwachtwoord, $json.internnummer, $wachtwoord, $First)
    if($hashtable["$result"]){
        Write-Host "Bewerking mislukt: "
        Write-host $hashtable["$result"]
    }
    else{
        write-host "Bewerking gelukt"
    }
}



SmSUser $EmailInterim $WachtWoordInterim $VoornaamInterim $NaamInterim
SmSCoAcc $EmailTeVervangenLeerkracht $WachtwoordInterim $VoornaamInterim $NaamInterim

#Emailadres en gebruikersnaam is op onze school hetzelfde. 
#Het intern nummer wordt bij leerkrachten niet echt gebruikt, dus zetten we dit hetzelfde als gebruikersnaam.
