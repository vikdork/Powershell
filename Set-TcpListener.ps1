function Set-TcpListener 
    {
        param ([int[]]$ports)
            for ($i = 1; $i -lt ($ports.Count + 1); $i++)
            { 
               New-Variable -Name ("Listener" + $ports[$i -1]) -Value ([System.Net.Sockets.TcpListener]$ports[$i -1]) -Scope Global
               (Get-Variable -Name ('Listener' + ($ports[$i -1])) -ValueOnly).start()
               
            }
}


  
