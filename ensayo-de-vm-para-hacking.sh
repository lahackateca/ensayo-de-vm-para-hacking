#!/bin/bash

### VERSIÓN: 1.0.3
VERSION="1.0.3"

# Manejo seguro de directorio temporal y limpieza al salir
TMP_DIR=$(mktemp -d /tmp/pentester_vm_XXXXXX)
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT INT TERM

### LOGO
# Definir los colores
readonly blanco='\033[1;37m'
readonly rojoh='\033[31m'
readonly aguamarinak='\033[38;5;44m'
readonly amarillo='\033[1;33m'
readonly verde='\033[0;32m'

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
║  ║▓║  Ensayo de VM para Hacking       ║▒║
╚══╩▓╩══════════════════════════════════╩╩╝${blanco}\n"


## FUNCIONES GENERALES

# función para diseñar los enunciados de los comandos
function banner_de_comandos() {
  printf "${rojoh}\n> $1${blanco}\n"
}

# Actualización del script
function actualizar_script {
    # Variables
    local REPO="lahackateca/ensayo-de-vm-para-hacking"
    # Busca dónde está el script local
    local SCRIPT_LOCAL
    SCRIPT_LOCAL=$(realpath "$0")
    local VERSION_LOCAL="${VERSION:-1.0.3}"
    local TMP_REPO_SCRIPT="$TMP_DIR/ensayo-de-vm-para-hacking-copia-repo.sh"

    # Chequear la última versión que figura dentro del script en GitHub
    local VERSION_DEL_REPO
    if ! VERSION_DEL_REPO=$(curl -s "https://raw.githubusercontent.com/${REPO}/main/ensayo-de-vm-para-hacking.sh"); then
        echo "Error al obtener la versión del repositorio."
        return 1
    fi
    # Guardar el script remoto en un archivo temporal
    echo "${VERSION_DEL_REPO}" > "$TMP_REPO_SCRIPT"

    # Obtener el número de versión del script remoto (buscando la etiqueta VERSIÓN:)
    local VERSION_ULTIMA
    VERSION_ULTIMA=$(grep -i "VERSIÓN:" "$TMP_REPO_SCRIPT" | head -n 1 | awk '{print $3}')
    
    if [ -z "$VERSION_ULTIMA" ]; then
        echo "No se pudo determinar la versión remota."
        return 1
    fi

    # Mostrar la versión local y la última versión
    echo -e "Versión: ${VERSION_LOCAL}. Última versión: ${VERSION_ULTIMA}"
    # Comparar las versiones
    if [ "$(printf '%s\n' "${VERSION_LOCAL}" "${VERSION_ULTIMA}" | sort -V | head -n1)" != "${VERSION_ULTIMA}" ]; then
        echo "Nueva versión encontrada. Actualizando..."
        if ! sudo cp "$TMP_REPO_SCRIPT" "${SCRIPT_LOCAL}"; then
            echo "Error al copiar el script actualizado. Asegúrate de tener permisos de superusuario."
            return 1
        fi
        echo -e "Actualización completada. Saliendo...\n"
        exit 0
    else
        echo -e "No se encontraron actualizaciones.\n"
    fi
}

## SEGURIDAD

# Cambiar las claves SSH que viene por defecto
cambiar_claves_ssh() {
    banner_de_comandos "Cambiando las claves SSH..."
    printf "\nRespaldando las claves por defecto\n"
    if [ ! -d /etc/ssh/keys_backup_ssh ]; then
        sudo mkdir -p /etc/ssh/keys_backup_ssh
    fi
    sudo mv /etc/ssh/ssh_host_* /etc/ssh/keys_backup_ssh/ 2>/dev/null
    
    printf "\nCreando nuevas claves\n"
    sudo dpkg-reconfigure openssh-server
    
    printf "\nVerificando si hay diferencia entre nuevas y claves por defecto\n"
    md5sum /etc/ssh/ssh_host_* 2>/dev/null
    md5sum /etc/ssh/keys_backup_ssh/ssh_host_* 2>/dev/null
}

# Actualizar el sistema y generar el script de actualización
actualizar_sistema_y_crear_script() {
    banner_de_comandos "Creando y ejecutando el script de actualización..."
    local script_path="/usr/local/bin/actualizar-linux.sh"
    
    # Escribir el script directamente en /usr/local/bin/actualizar-linux.sh
    echo -e '#!/bin/bash\nsudo apt update -y && sudo apt full-upgrade -y && sudo apt --purge autoremove -y && sudo apt autoclean -y' | sudo tee "$script_path" > /dev/null
    sudo chmod 755 "$script_path"
    
    # Ejecutar el script
    sudo "$script_path"
}

# Cambiar la contraseña del usuario kali
cambiar_contraseña_kali() {
    banner_de_comandos "Cambiando la contraseña del usuario kali..."
    local nuevo_password_kali
    echo -n "¿Cuál es la nueva contraseña del usuario Kali? "
    read -r nuevo_password_kali
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
    local usuario
    echo -n "Ingresa el nombre del usuario: "
    read -r usuario
    sudo adduser "$usuario"
}

## IDIOMA Y REGIÓN

# Cambiar el layout del teclado a Español (España)
cambiar_teclado_a_esp() {
    banner_de_comandos "Cambiando el idioma del teclado a Español (España)..."
    sudo sed -i 's/XKBOPTIONS="[^"]*"/XKBOPTIONS="\"es\""/' /etc/default/keyboard
    sudo sed -i 's/XKBLAYOUT="[^"]*"/XKBLAYOUT="es"/' /etc/default/keyboard
    sudo service keyboard-setup restart
    echo -e "\n  El idioma del teclado ahora es: $(grep XKBLAYOUT /etc/default/keyboard | cut -d "\"" -f2)"
}

# Cambiar zona horaria
cambiar_zona_horaria() {
    banner_de_comandos "Cambiando zona horaria..."
    sudo dpkg-reconfigure tzdata
    echo -e "\n La nueva zona horaria es: $(cat /etc/timezone)"
}

## INSTALAR PROGRAMAS

# Habilitar SSH
instalar_y_habilitar_ssh() {
    banner_de_comandos "Habilitando SSH..."
    sudo apt update
    sudo apt install openssh-server -y
    sudo systemctl enable ssh
    sudo systemctl start ssh
}

# Crear carpeta Scripts en Home, para instalar las herramientas
crear_carpeta_scripts() {
    banner_de_comandos "Creando estructura de carpetas..."
    local home_dir
    home_dir=$(eval echo "~${SUDO_USER:-$USER}")
    mkdir -p "${home_dir}/scripts"
}

# Descargar e instalar programas de la lista de La Hackateca
instalar_programas_hacking() {
    banner_de_comandos "Descargando e instalando programas de programas-hacking.list..."
    local home_dir
    home_dir=$(eval echo "~${SUDO_USER:-$USER}")
    local list_file="${TMP_DIR}/programas-hacking.list"

    curl -s https://raw.githubusercontent.com/lahackateca/compendio/refs/heads/main/programas-hacking.list -o "$list_file"
    
    # Iterar sobre cada línea del archivo programas-hacking.list
    local programa
    while IFS= read -r programa || [[ -n "$programa" ]]; do
        # Saltar líneas vacías o comentarios
        [[ -z "$programa" || "$programa" =~ ^# ]] && continue
        
        # Corregir crackmapexec a netexec si está en la lista (crackmapexec está descontinuado)
        if [[ "$programa" == "crackmapexec" ]]; then
            programa="netexec"
        fi

        # Verificar si el programa ya está instalado
        if dpkg -s "$programa" &> /dev/null; then
            echo -e "${blanco}[✔] $programa ya está instalado. Salteando...${blanco}"
            continue
        fi

        echo -e "${rojoh}Instalando $programa...${blanco}"
        if ! sudo apt install "$programa" -y; then
            echo -e "${rojoh}Error al instalar $programa. Continuando con el siguiente...${blanco}"
        fi
    done < "$list_file"

    # Instalar programas de repositorios git
    banner_de_comandos "Instalando programas desde programas-hacking-de-git.sh..."
    local git_script="${TMP_DIR}/programas-hacking-de-git.sh"
    curl -s https://raw.githubusercontent.com/lahackateca/proyectos/main/programas-hacking-de-git.sh -o "$git_script"
    if [ -f "$git_script" ]; then
        (cd "$home_dir" && bash "$git_script")
    fi

    # Descargar el pequeño pentester ilustrado
    banner_de_comandos "Instalando 'El pequeño pentester ilustrado'..."
    local script_dest="/usr/local/bin/el-pequenio-pentester-ilustrado.sh"
    if sudo wget -q "https://raw.githubusercontent.com/lahackateca/el-pequenio-pentester-ilustrado/refs/heads/main/el-pequenio-pentester-ilustrado.sh" -O "$script_dest"; then
        sudo chmod 755 "$script_dest"
        echo -e "${verde}[+] 'El pequeño pentester ilustrado' instalado en $script_dest${blanco}"
    else
        echo -e "${rojoh}[-] Error al descargar 'El pequeño pentester ilustrado'.${blanco}"
    fi
}

## OPTIMIZAR SISTEMA PARA PENTESTING

# Cambiar shell para que muestre fecha, hora, usuario, host y carpeta.
personalizar_shell() {
    banner_de_comandos "Personalizando shell..."
    local home_dir
    home_dir=$(eval echo "~${SUDO_USER:-$USER}")
    local zshrc_path="${home_dir}/.zshrc"

    if [ -f "$zshrc_path" ]; then
        cp "$zshrc_path" "${zshrc_path}.bak"
        # Comprobar si ya está personalizado
        if ! grep -q 'export PS1=' "$zshrc_path"; then
            echo 'export PS1="-[%F{green}%D{%a %b %d-%H:%M:%S}%f]-[%F{green}%n%f@%F{green}%m%f]-\n-[%F{green}%~%f]\$ "' >> "$zshrc_path"
            echo -e "${verde}[+] Shell personalizado. Los cambios se aplicarán al abrir una nueva terminal.${blanco}"
        else
            echo -e "${blanco}[✔] El shell ya tiene una personalización de PS1. Salteando...${blanco}"
        fi
    fi
}

## SISTEMA

# Sugerencias de HTB Academy y programas útiles de sistema
instalar_programas_de_sistema() {
    banner_de_comandos "Instalando programas de sistema..."
    local programas=(
        "preload"
        "bleachbit"
        "bum"
        "apt-file"
        "scrub"
        "shutter"
        "chkrootkit"
    )

    sudo apt update
    local programa
    for programa in "${programas[@]}"; do
        if dpkg -s "$programa" &> /dev/null; then
            echo -e "${blanco}[✔] $programa ya está instalado. Salteando...${blanco}"
            continue
        fi

        echo -e "${rojoh}Instalando $programa...${blanco}"
        sudo apt install -y "$programa"
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
    local opcion
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
                instalar_programas_de_sistema
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
    echo -e "\n"
    echo -e "${aguamarinak}Elegí una opción (o podés ingresar múltiples opciones separadas por espacio):${blanco}"
    echo -e "${aguamarinak}------------------------------${blanco}"
    echo "1. Cambiar claves SSH de Kali"
    echo "2. Actualizar Kali y crear script de actualización"
    echo "3. Cambiar la contraseña de usuario kali"
    echo "4. Cambiar la contraseña de root"
    echo "5. Crear usuario"
    echo "6. Cambiar teclado a español"
    echo "7. Cambiar zona horaria"
    echo "8. Instalar SSH"
    echo "9. Crear carpeta de Scripts"
    echo "10. Instalar programas de hacking"
    echo "11. Instalar programas de sistema"
    echo "12. Personalizar shell"
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
while true; do
    mostrar_menu
    if [[ $opciones =~ 99 ]]; then
        salir
    fi
    procesar_opciones "$opciones"
done
