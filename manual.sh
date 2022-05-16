#!/bin/bash
echo "content-type: text/html"
echo
#LEITURA DAS INFORMAÇÕES
read TRIPA

#fILTRO DAS INFORMAÇÕES
IP=$(echo "$TRIPA" | cut -d'=' -f2 | cut -d'&' -f1)
GW=$(echo "$TRIPA" | cut -d'=' -f3)

#CÓPIA DO AQRUIVO DE CONFIGURAÇÃO
sudo cp /etc/netplan/00-intaller-config.yaml 00-intaller-config.yaml.bkp

#ENVIO DAS INFORMAÇÕES PARA O ARQUIVO DE CONFIGURAÇÃO
echo "
network:
    ethernets:
        enp2s0:
           addresses: [$IP/24]
           dhcp4: false
           gateway4: $GW
    version: 2
" > /etc/netplan/00-installer-config.yaml

#APLICAÇÃO DAS CONFIGURAÇÕES
sudo netplan apply

#RETORNO PARA A PÁGINA INICIAL
echo '<html>'
echo '<head>'
echo '<meta http-equiv="refresh" content="0;url=manual-retorno.php">'
echo '</head>'
echo '</html>'

