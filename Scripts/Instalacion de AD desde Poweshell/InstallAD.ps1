function forestMode {

    $inputFM =Read-Host "
    
    Elije un nivel funcional del dominio del 0-7:

         >Windows Server 2000: 0 
         >Windows Server 2003 Interim Domain: 1
         >Windows Server 2003: 2 
         >Windows Server 2008: 3
         >Windows Server 2008 R2: 4
         >Windows Server 2012: 5 
         >Windows Server 2012 R2: 6 
         >Windows Server 2016: 7 
         
         " 


    if ( ($inputFM -lt 0) -or ($inputFM -gt 7) ) {
    
        Write-Host "Numero no valido, introduce de nuevo un numero dentro del rango 0-7"
        forestMode
    }
    
    else {
       
        return $inputFM
    
    }

    

}

function DomainMode {


    $inputDM =Read-Host "
    
    Elije un nivel funcional del dominio del 0-7:

         >Windows Server 2000: 0 
         >Windows Server 2003 Interim Domain: 1
         >Windows Server 2003: 2 
         >Windows Server 2008: 3
         >Windows Server 2008 R2: 4
         >Windows Server 2012: 5 
         >Windows Server 2012 R2: 6 
         >Windows Server 2016: 7 
         
         " 


    if ( ($inputDM -lt 0) -or ($inputDM -gt 7) ) {
    
        Write-Host "Numero no valido, introduce de nuevo un numero dentro del rango 0-7"
        forestMode
    }
    
    else {
       
        return $inputDM
    
    }



}


function configAD {

    $FM=forestMode
    $DM=DomainMode
    $DomainName = Read-Host "Instroduce el nombre del dominio (ejemplo : example.local)" 
    $netBIOS = ($DomainName -split '\.')[0]

    Install-ADDSForest -ForestMode $FM -DomainMode $DM -DomainName $DomainName -DomainNetBIOSName $netBIOS -DataBasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SYSVOLPath "C:\Windows\SYSVOL" -InstallDNS:$true -CreateDNSDelegation:$false -NoRebootOnCompletion:$false -Force:$true

}

#Verificar el estado del modulo 
if ((Get-WindowsFeature AD-Domain-Services  | Select-Object -ExpandProperty InstallState) -eq "Available" ){
    
    Write-Host "Modulo de AD disponible para instalar"
    sleep 5

    #Instalar Rol de Active Directory 
    Install-WindowsFeature AD-Domain-Services -IncludeManagementTools 
    configAD
}

else{

    Write-Host "AD ya esta instalado, se va a configurar"
    configAD
}