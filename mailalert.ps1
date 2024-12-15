# Configura i parametri SMTP e le credenziali
$smtpServer = "smtp.gmail.com"
$smtpPort = 587
$smtpUser = "tuoindirizzo@gmail.com"  # Sostituisci con il tuo indirizzo email
$smtpPassword = Read-Host "Inserisci la password (non visibile)" -AsSecureString

# Configura i dettagli dell'email
$from = "tuoindirizzo@gmail.com" # Sostituisci con il tuo indirizzo email
$to = @("destinatario@gmail.com") # Sostituisci con gli indirizzi dei destinatari
$subject = "Alert"
$bodyTemplate = "Connessione remota attiva. Ora di invio: {0}"

# Funzione per inviare l'email
function Send-AlertEmail {
    param(
        [string]$smtpServer,
        [int]$smtpPort,
        [string]$smtpUser,
        [securestring]$smtpPassword,
        [string]$from,
        [string[]]$to,
        [string]$subject,
        [string]$bodyTemplate
    )
    try {
        $currentDateTime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        $body = [string]::Format($bodyTemplate, $currentDateTime)

        $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
        $smtpClient.EnableSsl = $true
        $smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPassword)

        $mailMessage = New-Object System.Net.Mail.MailMessage
        $mailMessage.From = $from
        $to | ForEach-Object { $mailMessage.To.Add($_) }
        $mailMessage.Subject = $subject
        $mailMessage.Body = $body

        $smtpClient.Send($mailMessage)
        Write-Host "Email inviata con successo alle $currentDateTime."
    } catch {
        Write-Warning "Errore nell'invio dell'email: $_"
    }
}

# Ciclo per inviare un'email ogni ora
while ($true) {
    Send-AlertEmail -smtpServer $smtpServer -smtpPort $smtpPort -smtpUser $smtpUser -smtpPassword $smtpPassword -from $from -to $to -subject $subject -bodyTemplate $bodyTemplate
    Start-Sleep -Seconds 3600  # Attendi un'ora prima di inviare la prossima email
}
