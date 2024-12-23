# Configura il percorso del file JSON
$configPath = "C:\MailAlert\Config.json"
$config = Get-Content -Path $configPath | ConvertFrom-Json

# Leggi i parametri dal file JSON
$smtpServer = $config.smtpServer
$smtpPort = $config.smtpPort
$smtpUser = $config.smtpUser
$encryptedPasswordPath = $config.encryptedPasswordPath
$from = $config.from
$to = $config.to
$subject = "Alert"
$bodyTemplate = "Connessione remota attiva. Ora di invio: {0}"

# Decifra la password crittografata
$encryptedPassword = Get-Content -Path $encryptedPasswordPath
$smtpPassword = $encryptedPassword | ConvertTo-SecureString

# Percorso file di log
$logFilePath = "C:\MailAlert\Log\LogFile_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# Funzione per registrare log
function Log-Message {
    param (
        [string]$message,
        [string]$level = "INFO"
    )
    $timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    $logEntry = "$timestamp [$level] - $message"
    Write-Host $logEntry
    Add-Content -Path $logFilePath -Value $logEntry
}

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
        Log-Message -message "Tentativo di connessione al server SMTP $smtpServer sulla porta $smtpPort."
        $currentDateTime = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        $body = [string]::Format($bodyTemplate, $currentDateTime)

        $smtpClient = New-Object System.Net.Mail.SmtpClient($smtpServer, $smtpPort)
        $smtpClient.EnableSsl = $true
        $smtpClient.Timeout = 60000  # Timeout di 60 secondi
        $smtpClient.Credentials = New-Object System.Net.NetworkCredential($smtpUser, $smtpPassword)

        $mailMessage = New-Object System.Net.Mail.MailMessage
        $mailMessage.From = $from
        $to | ForEach-Object { $mailMessage.To.Add($_) }
        $mailMessage.Subject = $subject
        $mailMessage.Body = $body

        $smtpClient.Send($mailMessage)
        Log-Message -message "Email inviata con successo a $to alle $currentDateTime."
    } catch {
        $errorMessage = "Errore nell'invio dell'email: $_"
        Log-Message -message $errorMessage -level "ERROR"
    }
}

# Esegui il controllo della configurazione prima di iniziare il ciclo
if ($smtpServer -and $smtpPort -and $smtpUser -and $smtpPassword -and $from -and $to) {
    # Invia immediatamente la prima email
    Send-AlertEmail -smtpServer $smtpServer -smtpPort $smtpPort -smtpUser $smtpUser -smtpPassword $smtpPassword -from $from -to $to -subject $subject -bodyTemplate $bodyTemplate

    # Ciclo per inviare un'email ogni ora
    while ($true) {
        Start-Sleep -Seconds 3600  # Attendi un'ora prima di inviare la prossima email
        Send-AlertEmail -smtpServer $smtpServer -smtpPort $smtpPort -smtpUser $smtpUser -smtpPassword $smtpPassword -from $from -to $to -subject $subject -bodyTemplate $bodyTemplate
    }
} else {
    Log-Message -message "Errore nella configurazione. Controlla i parametri e riprova." -level "ERROR"
}
