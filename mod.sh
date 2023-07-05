#!/bin/bash

while true; do
    clear
    echo "Selecione uma opção:"
    echo "1. Modificar tela de Login do Multi100"
    echo "2. Personalizar cor hexadecimal"
    echo "3. Realizar build do frontend"
    echo "4. Sair"
    
    read -p "Opção: " opcao
    
    case $opcao in
        1)
            read -p "Qual o nome que gostaria para o app Multi100? " empresa
            
            sleep 2
            
            sudo su - deploy <<EOF
              cd /home/deploy/mod_100
            unzip -o mod_login.zip -d .
            rm mod_login.zip
            cp -Rf /home/deploy/mod_100/mod_login/assets/* /home/deploy/multi100/frontend/src/assets
            cp -f /home/deploy/mod_100/mod_login/index.js /home/deploy/multi100/frontend/src/pages/login
            cp -Rf /home/deploy/mod_100/mod_login/public/* /home/deploy/multi100/frontend/public

            sed -i "s/REACT_APP_NAME_SYSTEM=\"Multi100\"/REACT_APP_NAME_SYSTEM=\"$empresa\"/" /home/deploy/multi100/frontend/.env

            cd /home/deploy/multi100/frontend
            npm install react-lottie --force
EOF
            
            sleep 2
            
            read -p "Pressione qualquer tecla para continuar..."
        ;;
        
        2)
            read -p "Para qual cor hexadecimal quer trocar (PADRÃO #34BCFF)? " corhex
            
            find /home/deploy/multi100/frontend/ -type f -exec sed -i "s/#34BCFF/$corhex/g" {} \;
            
            read -p "Pressione qualquer tecla para continuar..."
        ;;
        
        3)
            sleep 2
            
            sudo su - deploy <<EOF
            cd /home/deploy/multi100/frontend
            npm run build
            pm2 restart all
EOF
            
            sleep 2
            
            read -p "Pressione qualquer tecla para continuar..."
        ;;
        
        4)
            exit
        ;;
        
        *)
            echo "Opção inválida. Pressione qualquer tecla para continuar..."
        ;;
    esac
done
