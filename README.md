# SmartschoolWebservice
Enkele voorbeeldscripts rond het gebruik van de webservice van Smartschool

## Interimaris.ps1
Dit is een stukje van een groter script. 
1. Bij het aanwerven van een nieuwe interimaris, wordt een Sharepoint lijst aangevuld met de gegevens van deze persoon door de directie. 
2. Na het invullen, loopt een Flow die ICT, Personeelsadministratie ... hiervan op de hoogte brengt via mail.
3. Er wordt een script gestart die de gegevens uit deze lijst uitleest. Aan de hand van de gegevens worden e-mailadres, wachtwoord en printercode gegenereerd. 
    1. Deze worden gebruikt om AD account en Smartschool (co-)accounts aan te maken. 
        **Dit laatste kan je in dit script terugvinden.**
    2. Uiteindelijk worden de gegevens doorgestuurd naar het persoonlijk e-mailadres van de interimaris en wordt er een Word document opgemaakt.
