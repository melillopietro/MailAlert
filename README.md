# Mail Alert Script

A PowerShell script for sending periodic alert emails using an SMTP server configured via a JSON file.

## Features
- Reads configuration from a JSON file.
- Supports encrypted passwords.
- Logs activity to a file with timestamps and severity levels.
- Automatically sends emails every hour.
- Handles errors during the email-sending process.

## Requirements
- **PowerShell** (version 5.1 or higher).
- Access to an SMTP server.
- A JSON file with the necessary configuration.

## Configuration
### JSON File
Create a configuration JSON file (e.g., `Config.json`) with the following format:
```json
{
    "smtpServer": "smtp.example.com",
    "smtpPort": 587,
    "smtpUser": "your-email@example.com",
    "encryptedPasswordPath": "C:\MailAlert\EncryptedPassword.txt",
    "from": "your-email@example.com",
    "to": ["recipient1@example.com", "recipient2@example.com"]
}
```

### Encrypting the Password
To protect the password, follow these steps:
1. Create an encrypted password and save it to a file:
   ```powershell
   "your-password" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\MailAlert\EncryptedPassword.txt"
   ```
2. Update the `EncryptedPassword.txt` file path in the JSON file.

## Usage
1. Ensure you have the `Config.json` file and the encrypted password file configured correctly.
2. Run the PowerShell script:
   ```powershell
   .\MailAlert.ps1
   ```

## Project Structure
```
MailAlert/
│
├── Config.json              # Configuration file
├── MailAlert.ps1            # PowerShell script
├── Log/                     # Directory for log files
│   └── LogFile_yyyyMMdd_HHmmss.txt
└── README.md                # Project documentation
```

## Logs
Logs are saved in `C:\MailAlert\Log\` with a filename that includes the date and time (`LogFile_yyyyMMdd_HHmmss.txt`). Each log entry includes:
- Timestamp.
- Message severity level (`INFO` or `ERROR`).
- Message description.

## Example Log Output
```
2024-12-23 10:00:00 [INFO] - Attempting to connect to SMTP server smtp.example.com on port 587.
2024-12-23 10:00:01 [INFO] - Email successfully sent to recipient1@example.com, recipient2@example.com at 2024-12-23 10:00:01.
2024-12-23 11:00:00 [ERROR] - Error sending email: Exception message.
```

## Future Improvements
- Integration with notification systems (e.g., Slack or Telegram).
- Ability to stop the loop with a specific command.
- Advanced configuration management using the `SecretManagement` module.

## License
This project is distributed under the MIT License. See the `LICENSE` file for details.
