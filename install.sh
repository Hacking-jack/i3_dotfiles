#!/bin/bash
# ===========================
#   Instalador de apps Arch
# ===========================

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No color

# ===========================
#   Paquetes a instalar
#   Añade o quita los que quieras
# ===========================

PACMAN_PACKAGES=(
    # Sistema
    base-devel
    xorg
    xorg-apps
	ly
	bash-completion
	starship
	pkgfile

    # i3 y entorno
    i3-wm
    i3blocks
    picom
    dunst
    rofi
    feh
    lxsession       # polkit agent

    # Terminal
    alacritty

    # Audio
    pulseaudio
    pulseaudio-alsa
    pavucontrol

    # Red
    networkmanager
    network-manager-applet

    # Fuentes
    ttf-jetbrains-mono-nerd
    ttf-nerd-fonts-symbols

    # Herramientas
    git
    curl
    wget
    htop
    fastfetch
    acpi
    wireless_tools
    dosfstools
    ntfs-3g

    # Editores
    neovim

    # Utilidades
    gdb
    valgrind
    clang

    # Navegador
    firefox
)

AUR_PACKAGES=(
	zen_browser_bin
	betterlockscreen
)

# ===========================
#   Funciones
# ===========================

print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════╗"
    echo "║     Instalador Arch Linux        ║"
    echo "╚══════════════════════════════════╝"
    echo -e "${NC}"
}

check_root() {
    if [ "$EUID" -eq 0 ]; then
        echo -e "${RED}No ejecutes este script como root.${NC}"
        exit 1
    fi
}

install_yay() {
    if ! command -v yay &>/dev/null; then
        echo -e "${YELLOW}Instalando yay (AUR helper)...${NC}"
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay && makepkg -si --noconfirm
        cd - && rm -rf /tmp/yay
        echo -e "${GREEN}yay instalado.${NC}"
    else
        echo -e "${GREEN}yay ya está instalado.${NC}"
    fi
}

install_pacman() {
    echo -e "${BLUE}Actualizando sistema...${NC}"
    sudo pacman -Syu --noconfirm

    echo -e "${BLUE}Instalando paquetes de pacman...${NC}"
    for pkg in "${PACMAN_PACKAGES[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            echo -e "  ${GREEN}✔ $pkg ya instalado${NC}"
        else
            echo -e "  ${YELLOW}➜ Instalando $pkg...${NC}"
            sudo pacman -S --noconfirm "$pkg" 2>/dev/null \
                && echo -e "  ${GREEN}✔ $pkg instalado${NC}" \
                || echo -e "  ${RED}✘ Error instalando $pkg${NC}"
        fi
    done
}

install_aur() {
    if [ ${#AUR_PACKAGES[@]} -eq 0 ]; then
        echo -e "${YELLOW}No hay paquetes AUR configurados.${NC}"
        return
    fi

    echo -e "${BLUE}Instalando paquetes de AUR...${NC}"
    for pkg in "${AUR_PACKAGES[@]}"; do
        if pacman -Qi "$pkg" &>/dev/null; then
            echo -e "  ${GREEN}✔ $pkg ya instalado${NC}"
        else
            echo -e "  ${YELLOW}➜ Instalando $pkg...${NC}"
            yay -S --noconfirm "$pkg" 2>/dev/null \
                && echo -e "  ${GREEN}✔ $pkg instalado${NC}" \
                || echo -e "  ${RED}✘ Error instalando $pkg${NC}"
        fi
    done
}

summary() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════╗"
    echo "║        Instalación completa      ║"
    echo "╚══════════════════════════════════╝"
    echo -e "${NC}"
}

configure_ly{
	if pacman -Qi ly &>/dev/null && systemctl is-active --quiet ly*;then
		sudo systemctl enable --now ly@tty1.service
}
# ===========================
#   Main
# ===========================
print_banner
check_root
install_pacman
install_yay
install_aur
summary



# Ruta donde está el script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"
HOME_DIR="$HOME"

echo "📁 Dotfiles desde: $SCRIPT_DIR"
echo "🔗 Enlazando a: $CONFIG_DIR y $HOME_DIR"

# Asegura que ~/.config existe
mkdir -p "$CONFIG_DIR"

# Enlazar directorios en .config
for dir in "$SCRIPT_DIR"/*/; do
    name=$(basename "$dir")

    # Evitar carpetas que no deben enlazarse
    [[ "$name" == ".git" ]] && continue

    echo "📂 Enlazando directorio $name → $CONFIG_DIR/$name"
    ln -sfn "$dir" "$CONFIG_DIR/$name"
done

# Enlazar archivos individuales
for file in "$SCRIPT_DIR"/.* "$SCRIPT_DIR"/*.conf; do
    filename=$(basename "$file")

    # Saltar si no es un archivo regular
    [[ ! -f "$file" ]] && continue

    case "$filename" in
        .bashrc | .zshrc | .bash_profile | .bash_logout )
            echo "📄 Enlazando $filename → $HOME_DIR/$filename"
            ln -sfn "$file" "$HOME_DIR/$filename"
            ;;
        *.conf )
            echo "📄 Enlazando $filename → $CONFIG_DIR/$filename"
            ln -sfn "$file" "$CONFIG_DIR/$filename"
            ;;
        * )
            # Saltar otros archivos ocultos o temporales
            ;;
    esac
done

echo "✅ Todos los enlaces han sido creados."
echo "ARRANCANDO EL SISTEMA................................"
configure_ly
