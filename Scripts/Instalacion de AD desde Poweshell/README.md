# Instalar AD Domain by PowerShell
**Este script de PowerShell está diseñado para automatizar el proceso de instalación y configuración de un dominio de Active Directory (AD) en un servidor Windows Server. Proporciona una interfaz sencilla para que el administrador seleccione las opciones de configuración necesarias. Las funciones principales son:**
* **Instalación de AD Domain Services:** Instala el rol de Active Directory si aún no está presente en el servidor.
* **Instalacion de herrramientas:** Instala las herramientas administrativas relacionadas con AD, como por ejemplo 'Usuarios y equipos del dominio'
* **Selección del nivel funcional:** Permite al usuario elegir el nivel funcional tanto del bosque como del dominio de AD, lo que determina las características y funcionalidades disponibles en el entorno.
* **Configuración de AD:** Configura el dominio recién creado, incluyendo:
   * Nombre de dominio
   * Nombre NetBIOS
   * Ubicación de la base de datos, registro y carpeta SYSVOL
   * Instalación de DNS

## Requisitos previos

* **PowerShell:** Versión 5.1 o superior.
* **Privilegios administrativos:** El script debe ejecutarse con privilegios de administrador.

## Instalación

1. **Descarga:** Descarga el script y guárdalo en una ubicación accesible.
2. **Ejecución:** Abre una ventana de PowerShell con privilegios administrativos y ejecuta el script utilizando el siguiente comando:

   ```powershell
   .\InstallAD.ps1

## **Características principales:**

* **Automatización:** Simplifica el proceso de instalación y configuración de AD, permtiendo desplegar un controlador de dominio de una manera rapida y sencilla.
* **Facilidad de uso:** La interfaz de usuario es intuitiva y fácil de entender.

## Disclaimer
Este script ha sido desarrollado como un proyecto personal para aprender y explorar las capacidades de PowerShell. Si bien se ha hecho todo lo posible para garantizar su correcto funcionamiento, es posible que contenga errores o limitaciones. 
El autor no se hace responsable de ningún daño o pérdida que pueda resultar del uso de este script. Se recomienda utilizar este script bajo su propia responsabilidad y realizar las pruebas necesarias antes de implementarlo en un entorno de producción.

