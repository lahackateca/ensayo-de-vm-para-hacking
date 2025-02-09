#!/bin/bash

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
         ${rojoh}:  .:         ${blanco}####    ###      ${rojoh}:::${blanco} #######  #####   ###      ${rojoh}:::${blanco}  ###      ###########  ######### .####     ####         
                       ####    ###      ${rojoh}:::${blanco} :#####   #####    ###     ${rojoh}:::${blanco}  ###      ###########   :######  ####      .####        
\n"

# nombre del script
echo -e "${aguamarinak}╔═══════════════════════════════════╗
                     \n      Ensayo de VM para hacking
                     \n╚═══════════════════════════════════╝${blanco}"


### FUNCIONES

## GENERALES DEL PROGRAMA

# Comando para diseñar los enunciados de los comandos
function banner() {
  printf "${rojoh}\n>>> $1${blanco}\n"
}

## SEGURIDAD

# Cambiar las claves SSH que viene por defecto
cambiar_claves_ssh() {
    banner "Cambiando las claves SSH..."
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
    banner "Creando y ejecutando el script de actualización..."
    echo "sudo apt update -y && sudo apt full-upgrade -y && sudo apt --purge autoremove -y && sudo apt autoclean -y" > ~/.local/bin/actualizar-linux.sh &&
    chmod 700  ~/.local/bin/actualizar-linux.sh &&
    # añado 'soft link' para poder ejecutarlo siempre.
    # Se podria añadir que se ejecute solo como un cron job cada semana, pero de momento no parece buena idea, ya que puede romper alguna herramienta
    sudo ln -s ~/.local/bin/actualizar-linux.sh /usr/local/bin/actualizar-linux.sh &&
    sudo actualizar-linux.sh
}

# Cambiar la contraseña del usuario kali
cambiar_contraseña_kali() {
    banner "Cambiando la contraseña del usuario kali..."
    # Acá se pide cuál va a ser el nuevo password del usuario Kali. No es necesario hacer tantos pasos, decidí agregar complejidad para dejar el script listo para automatizar esta parte, ya que se puede setear una variable acá o antes
    echo -n "¿Cuál es la nueva contraseña del usuario Kali? "
    read nuevo_password_kali
    echo "kali:${nuevo_password_kali}" | sudo chpasswd
}

# Cambiar la contraseña de root
cambiar_contraseña_root() {
    banner "Cambiando la contraseña de root..."
    sudo passwd root
}

# Crear un nuevo usuario
crear_usuario() {
    banner "Creando un nuevo usuario..."
    echo -n "Ingresa el nombre del usuario: "
    read usuario
    sudo adduser "$usuario"
}

## IDIOMA Y REGIÓN

# Cambiar el layout del teclado a Español (España). Créditos a PimpMyKali por la linea donde se lee el idioma actual - https://github.com/Dewalt-arch/pimpmykali)
cambiar_teclado_a_esp() {
    banner "Cambiando el idioma del teclado a Español (España)..."
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
    banner "Habilitando SSH..."
    sudo apt install openssh-server -y
    sudo systemctl enable ssh
    sudo systemctl start ssh
}

# Crear carpeta Scripts en Home, para instalar las herramientas
# TODO: modificarla para que cree carpetas para proyectos
crear_carpeta_scripts() {
    banner "Creando estructura de carpetas..."
    mkdir ~/scripts && cd ~
}

# Descargar e instalar programas de la lista de La Hackateca
instalar_programas_hacking() {
    banner "Descargando e instalando programas de programas-hacking.list..."
    # Iterar sobre cada línea del archivo programas-hacking.list
    while IFS= read -r programa; do
    echo -e "${rojoh}Instalando $programa.../n${blanco}"

    # Intentar instalar el programa y continuar si hay un error
    sudo apt install "$programa" -y
    if [ $? -ne 0 ]; then
        echo -e "${rojoh}Error al instalar $programa. Continuando con el siguiente.../n${blanco}"
    fi
    done < programas-hacking.list
    # TODO: crear link soft link para correr los programa más usados sin entrar a la carpeta
    banner "Instalando programas desde programas-hacking-de-git.sh..."
    curl -s https://raw.githubusercontent.com/lahackateca/proyectos/main/programas-hacking-de-git.sh | bash
    rm programas-hacking.list
    rm programas-hacking-de-git.sh
    # descargar el pequenio pentester ilustrado
    banner "Instalando 'El pequeño pentester ilustrado'..."
    wget "https://raw.githubusercontent.com/lahackateca/el-pequenio-pentester-ilustrado/refs/heads/main/el-pequenio-pentester-ilustrado.sh" &&
    chmod 700 el-pequenio-pentester-ilustrado.sh &&
    # crear link soft link para correr el programa sin entrar a la carpeta
    sudo ln -s ~/.local/bin/el-pequenio-pentester-ilustrado.sh /usr/local/bin/el-pequenio-pentester-ilustrado.sh &&
    cd ~
}

## OPTIMIZAR SISTEMA PARA PENTESTING

# Cambiar shell para que muestra fecha, hora, usuario, host, y carpeta desde donde se corre el comando. Útil para proporcionar la información de cuándo se corrieron los comandos si el cliente la pide.
personalizar_shell() {
    banner "Personalizando shell..."
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
    banner "Instalando VM Tools..."
    sudo apt update && sudo apt install -y --reinstall open-vm-tools-desktop fuse
}

### MENÚ

# Función para ejecutar todos los pasos
ejecutar_todos_los_comandos() {
    banner "Ejecutando todas las opciones..."
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
    personalizar_shell
}

# Función para salir del script
salir() {
    banner "Saliendo..."
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
    echo "Elegí una opción (o podés ingresar múltiples opciones separadas por espacio):"
    echo "------------------------------"
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
    echo "12. Personalizar shell"
    echo "------------------------------"
    echo "0. EJECUTAR TODOS LOS COMANDOS"
    echo "------------------------------"
    echo "99. SALIR"
    echo "------------------------------"
    read -p "Ingresá tus opciones: " opciones
}

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
