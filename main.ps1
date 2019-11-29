
#region SMTP VARIABLES
$kontenido = Get-Content '/home/monitor/kontenido.txt' | ConvertTo-SecureString
$smtpCred = New-Object -typename System.Management.Automation.PSCredential -argumentlist 'sender@mail.com', $kontenido
$fromAddress = 'sender@mail.com'
$smtpServer = 'smtp.office365.com'
$smtpPort = '587'
$mail = @{

    To = ''
    From = $fromAddress
    SmtpServer = $smtpServer
    Port = $smtpPort
    Credential = $smtpCred
    Subject = ''
    Body = ''

}
#endregions

#region TARGETS
$targets = Import-Csv '/home/monitor/targets.txt'

#endregion

#region MAIN

function main{

    Param([String] $computer, [String] $address, [String[]] $receivers, [Hashtable] $mail)
    
    $mail["To"] = $receivers

    while(1){
    
        # Below, ICMP test: three packages sent everytime with two seconds interval between them.
        $netTest = Test-Connection $address -Quiet -Count 3 -Delay 2

        if(!$netTest){

            $downTime = Get-Date
            $mail["Subject"] = "$computer Status DOWN"
            $mail["Body"] = "<h3>$computer Status:</h3><h3><span style='color:red;'>DOWN</span></h3><br><hr><p><em>This is an automatic alert, please do not reply.</em></p>"
            Send-MailMessage @mail -UseSsl -BodyAsHtml
            while(!$(Test-Connection $address -Quiet -Count 3 -Delay 2)){
                Write-Output $(Get-Date -f "MM-dd HH:mm:ss") "$computer status: DOWN" 
                }
            $totalDownTime = New-TimeSpan -Start $downTime -End $(Get-Date)
            $customDownTime = "Downtime: $($totalDownTime.Hours) hours, $($totalDownTime.Minutes) minutes, $($totalDownTime.Seconds) seconds."
            $mail["Subject"] = "$computer Status UP"
            $mail["Body"] = "<h3>$computer Status:</h3><h3><span style='color:green;'>UP</span></h3><h4>$customDownTime</h4><br><hr><p><em>This is an automatic alert, please do not reply.</em></p>"
            Send-MailMessage @mail -UseSsl -BodyAsHtml
        }else{
            Write-Output $(Get-Date -f "MM-dd HH:mm:ss") "$computer status: UP"
            }
    }

}

$targets | ForEach-Object {
    
    $recipients = @($_.Recipients.Split("|"))
    $aims = @($_.Hostname, $_.IP, $recipients, $mail)
    Start-Job -ScriptBlock ${function:main} -ArgumentList $aims

}

#endregion