
# Remote Connection Email Alert Script

A PowerShell script to send periodic email alerts regarding the status of a remote connection. The script can be configured to run indefinitely and send email notifications every hour.

## Features

- **SMTP Configuration**: Supports custom SMTP server, port, and credentials.
- **Periodic Alerts**: Sends emails every hour with the current date and time.
- **Customizable Recipients**: Allows sending alerts to multiple recipients.
- **Error Handling**: Captures and logs errors during the email sending process.
- **Secure Password Input**: Avoids saving plaintext passwords by using secure input.

---

## Prerequisites

Before using the script, ensure you have:

1. **PowerShell** installed:
   - Windows PowerShell 5.1 or higher.
   - PowerShell Core (for cross-platform usage).
2. A valid email account with SMTP enabled (e.g., Gmail, Outlook).
3. Network access to the SMTP server.

---

## How to Use

1. **Clone the Repository**:

   ```bash
   git clone https://github.com/your-username/remote-alert-script.git
   cd remote-alert-script
   ```

2. **Edit the Script**:
   - Open the script file and replace the placeholder values:
     - `$smtpUser`: Your email address.
     - `$to`: Recipient email addresses.
     - Update the `subject` and `bodyTemplate` as needed.

3. **Run the Script**:
   Execute the script in PowerShell:

   ```powershell
   ./alert-script.ps1
   ```

4. **Stop the Script**:
   Use `Ctrl+C` to stop the script manually.

---

## Configuration

The script uses the following parameters for email configuration:

| Parameter          | Description                     | Default Value         |
|--------------------|---------------------------------|-----------------------|
| `$smtpServer`      | SMTP server address            | `smtp.gmail.com`      |
| `$smtpPort`        | SMTP port                      | `587`                 |
| `$smtpUser`        | Email address for login        | *(Replace in script)* |
| `$smtpPassword`    | Email account password         | *(Secure input)*      |
| `$from`            | Sender email address           | *(Replace in script)* |
| `$to`              | Recipient email addresses      | *(Replace in script)* |
| `$subject`         | Email subject                 | `Alert`               |
| `$bodyTemplate`    | Body text template             | *(Current time)*      |

---

## Example Output

When the script runs successfully, you will see:

```
Email inviata con successo alle 2024-12-15 10:00:00.
```

If an error occurs, it will display:

```
Errore nell'invio dell'email: <error details>
```

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request with your proposed changes.

---

## Future Improvements

- Add more granular scheduling (e.g., Cron jobs).
- Support for additional email providers.
- Save logs to a file for long-term monitoring.
