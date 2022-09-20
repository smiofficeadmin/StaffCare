<#
    .NOTES
    ===============================================================
    Created on:     2022-09-09
    Created by:     Chris Scott
    Organisation:   SMI
    Filename:       SCLogFileTidy.ps1
    ===============================================================
    .Description
    This script is designed to be ran from the StaffCare bin folder and it deletes the logs from the following folders:
    -- StaffCare\logs, StaffCare\logs\emailed, StaffCare\logs\archive, StaffCare\bin_jadehttp\logs. StaffCare\bin_jadeWebSockets_IIS\logs and StaffCare\bin\app_jadehttp\logs.
#>

# Change the directory to the main StaffCare environment folder.
$MyInvocation.MyCommand.Path | Split-Path | Split-Path | Push-Location

# Vars
$OlderThanDays = "-15"
$TodaysDate = Get-Date
$15DaysOld = $TodaysDate.AddDays($OlderThanDays)

#Vars Dir Paths
$Logs = '.\logs' 
$LogsEmailed = '.\logs\emailed'
$LogsArchive = '.\logs\archive'
$LogsJadehttp = '.\bin_jadehttp\logs'
$LogsWebSockets = '.\bin_jadeWebSockets_IIS\logs'
$LogsApp = '.\bin\app_jadehttp\logs'

# Vars Array 
$AllLogs = @("$Logs", "$LogsEmailed", "$LogsArchive", "$LogsJadehttp", "$LogsWebSockets", "$LogsApp") 

# Remove Logs from all the path variables
Foreach-Object  {
    Get-ChildItem -File  $AllLogs | Where-Object {$_.LastWriteTime -lt $15DaysOld} |
        Remove-Item -Force -Verbose 4>&1 | Set-Content "$Logs\scLogFileTidy_$(Get-Date -format yyyyMMdd).txt" 
    }

    Pop-Location

# Finished!