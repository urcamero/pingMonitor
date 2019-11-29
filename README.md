# Overview

Maybe a snippet! but it may grow, main.ps1 send a ICMP test to several hosts at once working with Powershell jobs. main.ps1 tests 
communication with customizabled ICMP ('Test-Connection' cmdlet).

main.ps1 reports with mail notifications, if communication break down it sends a DOWN mail notification then when communication
is restablish its sends a UP mail notification (it will show downtime total).

![DOWN notification](https://github.com/urcamero/pingMonitor/blob/master/img/README/DOWN.png)

![UP notification](https://github.com/urcamero/pingMonitor/blob/master/img/README/UP.png)

##  Configuration 

Hosts are configured in 'targets.txt' and they are read as CSV, inside too can put specific and several recipients mails.

## Logs:

If you need some logs so type from terminal : 

    Get-Job # | Receive-Job | Out-File $logVault

or for remain

    Get-Job # | Receive-Job -Keep| Out-File $logVault

### Credits

    Original author: Mario Camero (ur.camero@gmail.com)
