param (
    [Parameter(Mandatory=$true)]
    [string]$Nombre,

    [Parameter(Mandatory=$true)]
    [string]$Apellidos,

    # Ahora este parámetro recibe la ruta completa (DistinguishedName) desde n8n
    [Parameter(Mandatory=$true)]
    [string]$RutaOU,

    # Mantenemos el nombre del departamento en texto plano por si queremos 
    # rellenar el campo "Department" del perfil del usuario en AD
    [Parameter(Mandatory=$true)]
    [string]$NombreDepartamento,

    [Parameter(Mandatory=$false)]
    [string]$Cargo = "Empleado"
)

try {
    Import-Module ActiveDirectory -ErrorAction Stop

    $NombreLimpio = [System.Text.Encoding]::ASCII.GetString([System.Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Nombre))
    $ApellidosLimpios = [System.Text.Encoding]::ASCII.GetString([System.Text.Encoding]::GetEncoding("Cyrillic").GetBytes($Apellidos))
    $NombreCompleto = "$Nombre $Apellidos"

    $UsuarioLogin = ($NombreLimpio.Substring(0,1) + $ApellidosLimpios.Replace(" ", "")).ToLower()

    if (Get-ADUser -Filter "SamAccountName -eq '$UsuarioLogin'") {
        throw "El nombre de usuario '$UsuarioLogin' ya existe en el dominio."
    }

    $Caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%"
    $PasswordTemporal = -join ((1..12) | ForEach-Object { $Caracteres[(Get-Random -Maximum $Caracteres.Length)] })
    $PasswordSegura = ConvertTo-SecureString $PasswordTemporal -AsPlainText -Force

    # La creación utiliza ahora la variable dinámica $RutaOU
    New-ADUser -Name $NombreCompleto `
               -GivenName $Nombre `
               -Surname $Apellidos `
               -SamAccountName $UsuarioLogin `
               -UserPrincipalName "$UsuarioLogin@pepe.local" `
               -Department $NombreDepartamento `
               -Title $Cargo `
               -Path $RutaOU `
               -AccountPassword $PasswordSegura `
               -Enabled $true `
               -ChangePasswordAtLogon $true 

          # -------------------------------------------------------------------
    # ASIGNACIÓN DE GRUPOS DE SEGURIDAD BASADA EN DEPARTAMENTO
    # -------------------------------------------------------------------

    # Definimos los grupos a los que pertenecerá según el departamento.
    # Usamos arrays (@) por si en el futuro un departamento necesita entrar en varios grupos a la vez (ej. su carpeta y la VPN).
    switch ($NombreDepartamento) {
        "Contabilidad" {
            $Grupos = @("G_Contabilidad")
        }
        "Informatica" {
            $Grupos = @("G_Informatica", "G_Admins_Locales")
        }
        "RRHH" {
            $Grupos = @("G_RRHH")
        }
        
        default {
            # Si el departamento no coincide o está en blanco, le damos un grupo básico
            $Grupos = @("G_Usuarios_Estandar")
        }
    }

    # Recorremos la lista de grupos asignados y metemos al usuario
    foreach ($Grupo in $Grupos) {
        try {
            # El parámetro ErrorAction Stop fuerza a que si el grupo no existe en el AD, salte al catch
            Add-ADGroupMember -Identity $Grupo -Members $UsuarioLogin -ErrorAction Stop
        } 
        catch {
            # Escribimos el error en un archivo de texto local en el servidor a modo de log.
            # No rompemos el script principal porque el usuario ya está creado y necesita sus credenciales.
            $FechaHora = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Add-Content -Path "C:\tmp\Errores_Grupos_AD.log" -Value "[$FechaHora] Error al añadir al usuario $UsuarioLogin al grupo $Grupo. Detalle: $($_.Exception.Message)"
        }
    }
    # -------------------------------------------------------------------

    $Respuesta = @{
        "Estado" = "Exito"
        "Mensaje" = "Usuario $NombreCompleto creado correctamente en la OU."
        "Login" = $UsuarioLogin
        "PasswordTemporal" = $PasswordTemporal
        "RutaDestino" = $RutaOU
    }

    $Respuesta | ConvertTo-Json

} catch {
    $ErrorRespuesta = @{
        "Estado" = "Error"
        "Mensaje" = $_.Exception.Message
    }
    $ErrorRespuesta | ConvertTo-Json
}