#!/bin/bash

# Définition des couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # Pas de couleur

# Initialisation du rapport
rapport=""

# Fonction pour vérifier l'état de la commande précédente et mettre à jour le rapport
check_installation() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Échec de l'installation de $1.${NC}"
        rapport+="${RED}$1: Échec${NC}\n"
    else
        echo -e "${GREEN}Installation de $1 réussie.${NC}"
        rapport+="${GREEN}$1: Réussi${NC}\n"
    fi
}

# Mise à jour des packages Ubuntu
echo "Mise à jour des packages..."
sudo apt-get update -y > /dev/null 2>&1
check_installation "Mise à jour des packages"
sudo apt-get upgrade -y > /dev/null 2>&1
check_installation "Upgrade des packages"

# Installation des dépendances de base pour Python
echo "Installation de Python et dépendances..."
sudo apt-get install -y python3 python3-pip python3.10 unzip > /dev/null 2>&1
check_installation "Python et dépendances"

# Installation des modules Python
echo "Installation des modules Python..."
sudo pip3 install requests bs4 dulwich socks PySocks pyopenssl > /dev/null 2>&1
check_installation "Modules Python"

# Mise à jour de pyopenssl pour Python
echo "Mise à jour de pyopenssl..."
sudo rm -rf /usr/lib/python3/dist-packages/OpenSSL
yes | sudo pip3 install pyopenssl --upgrade > /dev/null 2>&1
check_installation "Mise à jour de pyopenssl"

# Installation des outils supplémentaires
echo "Installation des outils supplémentaires..."
sudo snap install httpx > /dev/null 2>&1
check_installation "Httpx"
sudo apt-get install -y awscli jq parallel dos2unix > /dev/null 2>&1
check_installation "Outils supplémentaires"

# Affichage du rapport final
echo -e "\nRapport d'installation :"
echo -e "$rapport"

source ~/.bashrc
