#!/bin/bash

### VERSIÓN: 1.0.2

# TODO: a futuro. De momento no lo hago para simplificar
# Archivo de configuración
# source config.sh

### LOGO
# Definir los colores
blanco='\033[1;37m'
rojoh='\033[31m'
# rgb(116, 228, 228)
aguamarinak='\033[38;5;44m'

# logo la hackateca
echo -e "\n

	    ${blanco}
      ${rojoh}.::::::::        ${blanco}LA                                                                                                          
    ${rojoh}::::  .::::::                      :.${blanco}                            ${rojoh}.${blanco}                                                            
   ${rojoh}::::   : ::::::     ${blanco}####    ###   ${rojoh}.::::${blanco}  #######  ###     ####  ${rojoh}.:::::${blanco}########## ###########   :######      ######.            
   ${rojoh}:::  :  :    ::.    ${blanco}####    ###  ${rojoh}::: ::${blanco}#########  ###   ####.   ${rojoh}::::::${blanco}########## ########### -#########    ########            
   ${rojoh}:      .     ::.    ${blanco}########### ${rojoh}:::. :::${blanco}##        ###  ####   ${rojoh}:::: :::${blanco}  ###      ###         ###.          #### ####           
      ${rojoh}:. :.    :::     ${blanco}##########${rojoh}-:::   :::${blanco}#+        ### #####  ${rojoh}:::.  :::${blanco}  ###      ##########+ ###          ####   ####          
       ${rojoh}.     .:::      ${blanco}####    #${rojoh}::::    :::${blanco}###.  ##  ###### ###${rojoh}:::    :::${blanco}  ###      ###         ####.  ##   ####    ####          
         ${rojoh}:  .:         ${blanco}####    ###      ${rojoh}:::${blanco} #######  #####   ###      ${rojoh}:::${blanco}  ###      ###########  ########  .####     ####         
                       ####    ###      ${rojoh}:::${blanco} :#####   #####    ###     ${rojoh}:::${blanco}  ###      ###########   :######  ####      .####        
\n"

# nombre del script
echo -e "${aguamarinak}╔══╦▓╦══════════════════════════════════╦╦╗
║  ║▓║  Ensayo de VM para hacking       ║▒║
╚══╩▓╩══════════════════════════════════╩╩╝${blanco}\n"


## FUNCIONES GENERALES
# Actualización del script
function actualizar_script {
    # Variables
    REPO="lahackateca/ensayo-de-vm-para-hacking"
    # Donde está el script local. Cambiar si es necesario
    SCRIPT_LOCAL="/usr/bin/ensayo-de-vm-para-hacking.sh"
    # Obtener el número de versión del script local
    VERSION_LOCAL=$(sed -n '3p' ${SCRIPT_LOCAL} | cut -d ' ' -f 3)
    # Chequear la última versión que figura dentro del script en GitHub
    VERSION_DEL_REPO=$(curl -s https://raw.githubusercontent.com/${REPO}/main/ensayo-de-vm-para-hacking.sh)
    if [ $? -ne 0 ]; then
        echo "Error al obtener la versión del repositorio."
        exit 1
    fi
    # Guardar el script remoto en un archivo temporal
    echo "${VERSION_DEL_REPO}" > /tmp/el-pequenio-pentester-ilustrado-copia-repo.sh
    if [ $? -ne 0 ]; then
        echo "Error al guardar el script remoto en un archivo temporal."
        exit 1
    fi
    # Obtener el número de versión del script remoto
    VERSION_ULTIMA=$(sed -n '3p' /tmp/el-pequenio-pentester-ilustrado-copia-repo.sh | cut -d ' ' -f 3)
    # Mostrar la versión local y la última versión
    echo -e "Versión: ${VERSION_LOCAL}. Última versión: ${VERSION_ULTIMA}"
    # Comparar las versiones
    if [ "$(printf '%s\n' "${VERSION_LOCAL}" "${VERSION_ULTIMA}" | sort -V | head -n1)" != "${VERSION_ULTIMA}" ]; then
        echo "Nueva versión encontrada. Actualizando..."
        sudo cp /tmp/el-pequenio-pentester-ilustrado-copia-repo.sh ${SCRIPT_LOCAL}
        if [ $? -ne 0 ]; then
            echo "Error al copiar el script actualizado. Asegúrate de tener permisos de superusuario."
            rm /tmp/el-pequenio-pentester-ilustrado-copia-repo.sh
            exit 1
        fi
        echo -e "Actualización completada. Saliendo...\n"
        exit 0
    else
        echo -e "No se encontraron actualizaciones.\n"
    fi

    # Limpiar el archivo temporal
    rm /tmp/el-pequenio-pentester-ilustrado-copia-repo.sh
}

# función para diseñar los enunciados de los comandos
function banner_de_comandos() {
  printf "${rojoh}\n> $1${blanco}\n"
}

# Actualización del script
function actualizar_script {
    # Variables
    REPO="lahackateca/ensayo-de-vm-para-hacking"
    # Busca dónde está el script local
    SCRIPT_LOCAL=$(realpath "$0")
    # Obtener el número de versión del script local
    VERSION_LOCAL=$(sed -n '3p' ${SCRIPT_LOCAL} | cut -d ' ' -f 3)
    # Chequear la última versión que figura dentro del script en GitHub
    VERSION_DEL_REPO=$(curl -s https://raw.githubusercontent.com/${REPO}/main/ensayo-de-vm-para-hacking.sh)
    if [ $? -ne 0 ]; then
        echo "Error al obtener la versión del repositorio."
        exit 1
    fi
    # Guardar el script remoto en un archivo temporal
    echo "${VERSION_DEL_REPO}" > /tmp/ensayo-de-vm-para-hacking-copia-repo.sh
    if [ $? -ne 0 ]; then
        echo "Error al guardar el script remoto en un archivo temporal."
        exit 1
    fi
    # Obtener el número de versión del script remoto
    VERSION_ULTIMA=$(sed -n '3p' /tmp/ensayo-de-vm-para-hacking-copia-repo.sh | cut -d ' ' -f 3)
    # Mostrar la versión local y la última versión
    echo -e "Versión: ${VERSION_LOCAL}. Última versión: ${VERSION_ULTIMA}"
    # Comparar las versiones
    if [ "$(printf '%s\n' "${VERSION_LOCAL}" "${VERSION_ULTIMA}" | sort -V | head -n1)" != "${VERSION_ULTIMA}" ]; then
        echo "Nueva versión encontrada. Actualizando..."
        sudo cp /tmp/ensayo-de-vm-para-hacking-copia-repo.sh ${SCRIPT_LOCAL}
        if [ $? -ne 0 ]; then
            echo "Error al copiar el script actualizado. Asegúrate de tener permisos de superusuario."
            rm /tmp/ensayo-de-vm-para-hacking-copia-repo.sh
            exit 1
        fi
        echo -e "Actualización completada. Saliendo...\n"
        exit 0
    else
        echo -e "No se encontraron actualizaciones.\n"
    fi

    # Limpiar el archivo temporal
    rm /tmp/el-pequenio-pentester-ilustrado-copia-repo.sh
}

## SEGURIDAD

# Cambiar las claves SSH que viene por defecto
cambiar_claves_ssh() {
    banner_de_comandos "Cambiando las claves SSH..."
    printf "\nRespaldando las claves por defecto\n" &&
    cd /etc/ssh &&
    mkdir keys_backup_ssh &&
    mv ssh_host_* keys_backup_ssh &&
    printf "\nCreando nuevas claves\n" &&
    sudo dpkg-reconfigure openssh-server
    printf "\nVerificando si hay diferencia entre nuevas y claves por defecto\n" &&
    md5sum /etc/ssh/ssh_host_* && md5sum /etc/ssh/keys_backup_ssh/ssh_host_*
}

# Actualizar el sistema y generar el script de actualización
actualizar_sistema_y_crear_script() {
    banner_de_comandos "Creando y ejecutando el script de actualización..."
    echo "sudo apt update -y && sudo apt full-upgrade -y && sudo apt --purge autoremove -y && sudo apt autoclean -y" > ~/.local/bin/actualizar-linux.sh &&
    chmod 700  ~/.local/bin/actualizar-linux.sh &&
    # añado 'soft link' para poder ejecutarlo siempre.
    # Se podria añadir que se ejecute solo como un cron job cada semana, pero de momento no parece buena idea, ya que puede romper alguna herramienta
    sudo ln -s ~/.local/bin/actualizar-linux.sh /usr/local/bin/actualizar-linux.sh &&
    sudo actualizar-linux.sh
}

# Cambiar la contraseña del usuario kali
cambiar_contraseña_kali() {
    banner_de_comandos "Cambiando la contraseña del usuario kali..."
    # Acá se pide cuál va a ser el nuevo password del usuario Kali. No es necesario hacer tantos pasos, decidí agregar complejidad para dejar el script listo para automatizar esta parte, ya que se puede setear una variable acá o antes
    echo -n "¿Cuál es la nueva contraseña del usuario Kali? "
    read nuevo_password_kali
    echo "kali:${nuevo_password_kali}" | sudo chpasswd
}

# Cambiar la contraseña de root
cambiar_contraseña_root() {
    banner_de_comandos "Cambiando la contraseña de root..."
    sudo passwd root
}

# Crear un nuevo usuario
crear_usuario() {
    banner_de_comandos "Creando un nuevo usuario..."
    echo -n "Ingresa el nombre del usuario: "
    read usuario
    sudo adduser "$usuario"
}

## IDIOMA Y REGIÓN

# Cambiar el layout del teclado a Español (España). Créditos a PimpMyKali por la linea donde se lee el idioma actual - https://github.com/Dewalt-arch/pimpmykali)
cambiar_teclado_a_esp() {
    banner_de_comandos "Cambiando el idioma del teclado a Español (España)..."
    sudo sed -i 's/XKBOPTIONS="[^"]*"/XKBOPTIONS="\"es\""/' /etc/default/keyboard
    sudo sed -i 's/XKBLAYOUT="[^"]*"/XKBLAYOUT="es"/' /etc/default/keyboard
    sudo service keyboard-setup restart
    echo -e "\n  El idioma del teclado ahora es: $(cat /etc/default/keyboard | grep XKBLAYOUT | cut -d "\"" -f2)"
}

# Cambiar zona horaria (créditos a PimpMyKali - https://github.com/Dewalt-arch/pimpmykali)
# Muestra un menú para elegirla
cambiar_zona_horaria() {
    sudo /bin/bash --rcfile /home/$finduser/.zshrc -ic 'dpkg-reconfigure tzdata' 2>/dev/null
    echo -e "\n La nueva zona horaria es: $(cat /etc/timezone)"
}

## INSTALAR PROGRAMAS

# Habilitar SSH
instalar_y_habilitar_ssh() {
    banner_de_comandos "Habilitando SSH..."
    sudo apt install openssh-server -y
    sudo systemctl enable ssh
    sudo systemctl start ssh
}

# Crear carpeta Scripts en Home, para instalar las herramientas
# TODO: modificarla para que cree carpetas para proyectos
crear_carpeta_scripts() {
    banner_de_comandos "Creando estructura de carpetas..."
    mkdir ~/scripts && cd ~
}

# Descargar e instalar programas de la lista de La Hackateca
instalar_programas_hacking() {
    banner_de_comandos "Descargando e instalando programas de programas-hacking.list..."
	curl -s https://raw.githubusercontent.com/lahackateca/compendio/refs/heads/main/programas-hacking.list -o programas-hacking.list
	# Iterar sobre cada línea del archivo programas-hacking.list
	while IFS= read -r programa; do
	    # Saltar líneas vacías o comentarios
	    [[ -z "$programa" || "$programa" =~ ^# ]] && continue
	
	    # Verificar si el programa ya está instalado
	    if dpkg -s "$programa" &> /dev/null; then
	        echo -e "${blanco}[✔] $programa ya está instalado. Salteando...${blanco}"
	        continue
	    fi
	
	    echo -e "${rojoh}Instalando $programa...${blanco}"
	    # Intentar instalar el programa y continuar si hay un error
	    if ! sudo apt install "$programa" -y; then
	        echo -e "${rojoh}Error al instalar $programa. Continuando con el siguiente...${blanco}"
	    fi
	done < programas-hacking.list
    # TODO: crear link soft link para correr los programa más usados sin entrar a la carpeta
    banner_de_comandos "Instalando programas desde programas-hacking-de-git.sh..."
    curl -s https://raw.githubusercontent.com/lahackateca/proyectos/main/programas-hacking-de-git.sh | bash
    rm programas-hacking.list
    rm programas-hacking-de-git.sh
    # descargar el pequenio pentester ilustrado
    banner_de_comandos "Instalando 'El pequeño pentester ilustrado'..."
    wget "https://raw.githubusercontent.com/lahackateca/el-pequenio-pentester-ilustrado/refs/heads/main/el-pequenio-pentester-ilustrado.sh" &&
    chmod 700 el-pequenio-pentester-ilustrado.sh &&
    # crear link soft link para correr el programa sin entrar a la carpeta
    sudo ln -s ~/.local/bin/el-pequenio-pentester-ilustrado.sh /usr/local/bin/el-pequenio-pentester-ilustrado.sh &&
    cd ~
}

## OPTIMIZAR SISTEMA PARA PENTESTING

# Cambiar shell para que muestra fecha, hora, usuario, host, y carpeta desde donde se corre el comando. Útil para proporcionar la información de cuándo se corrieron los comandos si el cliente la pide.
personalizar_shell() {
    banner_de_comandos "Personalizando shell..."
    # Primero se hace copia por las dudas
    cp ~/.zshrc ~/.zshrc.bak
    # Después se agrega al zshrc original
    echo 'export PS1="-[%F{green}%D{%a %b %d-%H:%M:%S}%f]-[%F{green}%n%f@%F{green}%m%f]-\n-[%F{green}%~%f]\$ "' >> ~/.zshrc &&
    # Y se recarga el zshrc para que se apliquen los cambios
    source ~/.zshrc
}

## SISTEMA

# Función para instalar VM Tools, si estás virtualizando Kali en VMWare
# https://www.kali.org/docs/virtualization/install-vmware-guest-tools/
instalar_vm_tools() {
    banner_de_comandos "Instalando VM Tools..."
    sudo apt update && sudo apt install -y --reinstall open-vm-tools-desktop fuse
}

# Sugerencias de HTB Academy, mejoras de inicio de aplicaciones, privacidad, deshabilitación de servicios innecesarios, y más
# TODO: usar una lista en github, como con los programas para hacking
instalar_programas_de_sistema() {
    banner_de_comandos "Instalando programas de sistema..."

    # Lista de programas a instalar
    programas=(
        "preload"
        "bleachbit"
        "bum"
        "apt-file"
        "scrub"
        "shutter"
        "chkrootkit"
    )

    # Instalar cada programa
    for programa in "${programas[@]}"; do
        echo -e "${rojoh}Instalando $programa...${blanco}"
        if [ "$programa" == "shutter" ]; then
            add-apt-repository -y ppa:linuxuprising/shutter &&
            apt-get update
        fi
        apt-get install -y "$programa"
    done
}

### MENÚ

# Función para ejecutar todos los pasos
ejecutar_todos_los_comandos() {
    banner_de_comandos "Ejecutando todas las opciones..."
    cambiar_claves_ssh
    actualizar_sistema_y_crear_script
    cambiar_contraseña_kali
    cambiar_contraseña_root
    crear_usuario
    cambiar_teclado_a_esp
    cambiar_zona_horaria
    instalar_y_habilitar_ssh
    crear_carpeta_scripts
    instalar_programas_hacking
    instalar_vm_tools
    instalar_programas_de_sistema
    personalizar_shell
}

# Función para salir del script
salir() {
    banner_de_comandos "Saliendo..."
    exit 0
}

# Función para procesar las opciones seleccionadas
procesar_opciones() {
    for opcion in $1; do
        case $opcion in
            0)
                ejecutar_todos_los_comandos
                ;;
            1)
                cambiar_claves_ssh
                ;;
            2)
                actualizar_sistema_y_crear_script
                ;;
            3)
                cambiar_contraseña_kali
                ;;
            4)
                cambiar_contraseña_root
                ;;
            5)
                crear_usuario
                ;;
            6)
                cambiar_teclado_a_esp
                ;;
            7)
                cambiar_zona_horaria
                ;;
            8)
                instalar_y_habilitar_ssh
                ;;
            9)
                crear_carpeta_scripts
                ;;
            10)
                instalar_programas_hacking
                ;;
            11)
                instalar_vm_tools
                ;;
            12)
                instalar_programas_de_sistema
                ;;                
            13)		
		        personalizar_shell
                ;;
            *)
                echo "Marcaste una opción no válida: $opcion"
                ;;
        esac
    done
}

# Menú interactivo
mostrar_menu() {
    echo -e "\n"
    echo -e "${aguamarinak}Elegí una opción (o podés ingresar múltiples opciones separadas por espacio):${blanco}"
    echo -e "${aguamarinak}------------------------------${blanco}"
    echo "1. Cambiar claves SSH de Kali"
    echo "2. Actualizar Kali y descargar script"
    echo "3. Cambiar la contraseña de usuario kali"
    echo "4. Cambiar la contraseña de root"
    echo "5. Crear usuario"
    echo "6. Cambiar teclado a español"
    echo "7. Cambiar zona horaria"
    echo "8. Instalar SSH"
    echo "9. Crear carpeta Scripts"
    echo "10. Instalar programas de hacking"
    echo "11. Instalar VM Tools"
    echo "12. Instalar programas de sistema"
    echo "13. Personalizar shell"
    echo -e "${aguamarinak}------------------------------${blanco}"
    echo "0. EJECUTAR TODOS LOS COMANDOS"
    echo -e "${aguamarinak}------------------------------${blanco}"
    echo "99. SALIR"
    echo -e "${aguamarinak}------------------------------${blanco}"
    read -p "Ingresá tu(s) opción(es): " opciones
}

## Iniciar programa
# Chequear por actualización de este script
actualizar_script
# Bucles y control de flujo para poder seleccionar varias opciones
# TODO: Cambiar el número de la opción de salir si se agregan opciones al menú
while true; do
    mostrar_menu
    # si el número ingresado es o contiene el número 99, llama a la función salir
    if [[ $opciones =~ 99 ]]; then
        salir
    fi
    procesar_opciones "$opciones"
done
