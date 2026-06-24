# Website Monitoring Script
PowerShell script for monitoring website availability using Invoke-WebRequest.

## Features
- Accepts a website URL as a command-line parameter
- Checks if the URL parameter is provided
- Verifies website availability
- Tests HTTP (80) and HTTPS (443) connectivity 3 times each
- Logs response status codes and descriptions
- Calculates average response time
- Calculates average response size
- Writes all results to a log file

## Usage
```powershell
.\script.ps1 -url mail.ru
