get-nettcpconnection | Where-Object {$_.State -eq "Listen" -and ( $_.RemoteAddress -eq "0.0.0.0")} | Select-Object LocalAddress,LocalPort,RemoteAddress,RemotePort,State,OwningProcess,@{Name="Process Name";Expression={(Get-Process -Id $_.OwningProcess).ProcessName}} | ft 


function Get-LoggedOnUser
 {
     [CmdletBinding()]
     param
     (
         [Parameter()]
         [ValidateScript({ Test-Connection -ComputerName $_ -Quiet -Count 1 })]
         [ValidateNotNullOrEmpty()]
         [string[]]$ComputerName = $env:COMPUTERNAME
     )
     foreach ($comp in $ComputerName)
     {
         $output = @{ 'ComputerName' = $comp }
         $output.UserName = (Get-WmiObject -Class win32_computersystem -ComputerName $comp).UserName
         [PSCustomObject]$output
     }
 }

 Get-LoggedOnUser