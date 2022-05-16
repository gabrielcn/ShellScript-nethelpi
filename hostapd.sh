#!/bin/bash
echo "content-type: text/html"
echo
#LEITURA DAS INFORMAÇÕES ENVIADAS
read TRIPA

echo "$TRIPA"
echo "<br> <br>"

#FILTROS PARA SEPARAR AS INFORMAÇÕES
SSID=$(echo "$TRIPA" | cut -d'&' -f1 | cut -d'=' -f2)
echo "$SSID"
PASS=$(echo "$TRIPA" | cut -d'&' -f2 | cut -d'=' -f2)
echo "$PASS"
CHANNEL=$(echo "$TRIPA" | cut -d'&' -f3 | cut -d'=' -f2)
echo "$CHANNEL"
SUBNET=$(echo "$TRIPA" | cut -d'&' -f4 | cut -d'=' -f2)
echo "$SUBNET"
ADDRESS=$(echo "$TRIPA" | cut -d'&' -f5 | cut -d'=' -f2)
echo "$ADDRESS"
NETMASK=$(echo "$TRIPA" | cut -d'&' -f6 | cut -d'=' -f2)
echo "$NETMASK"
BROADCAST=$(echo "$TRIPA" | cut -d'&' -f7 | cut -d'=' -f2)
echo "$BROADCAST"
RSTART=$(echo "$TRIPA" | cut -d'&' -f8 | cut -d'=' -f2)
echo "$RSTART"
REND=$(echo "$TRIPA" | cut -d'&' -f9 | cut -d'=' -f2)
echo "$REND"
DNS1=$(echo "$TRIPA" | cut -d'&' -f10 | cut -d'=' -f2)
echo "$DNS1"
DNS2=$(echo "$TRIPA" | cut -d'&' -f11 | cut -d'=' -f2)
echo "$DNS2"

#INTERFACES - /etc/network/interfaces

sudo ifdown wlx6466b31c7efe

#ADDRESS
sed -i "s/address.*/address $ADDRESS"/ /etc/network/interfaces

#NETMASK
sed -i "s/netmask.*/netmask $NETMASK"/ /etc/network/interfaces

#SUBNET
sed -i "s/network.*/network $SUBNET"/ /etc/network/interfaces

#BROADCAST
sed -i "s/broadcast.*/broadcast $BROADCAST"/ /etc/network/interfaces

sudo ifup wlx6466b31c7efe

#HOSTAPD - /etc/hostapd/hostapd.conf

sudo service hostapd stop

#SSID
sed -i "s/ssid=.*/ssid=$SSID"/ /etc/hostapd/hostapd.conf

#PASS
sed -i "s/wpa_passphrase=.*/wpa_passphrase=$PASS"/ /etc/hostapd/hostapd.conf

#CHANNEL
sed -i "s/channel=.*/channel=$CHANNEL"/ /etc/hostapd/hostapd.conf

sudo service hostapd start

#DHCP - /etc/dhcp/dhcpd.conf

sudo systemctl stop isc-dhcp-server


#SUBNET e NETMASK
sed -i "s/subnet.*/subnet $SUBNET netmask $NETMASK {"/ /etc/dhcp/dhcpd.conf

#RSTART e REND
sed -i "s/range.*/range $RSTART $REND;"/ /etc/dhcp/dhcpd.conf

#DNS1 e DNS2
sed -i "s/option domain-name-servers.*/option domain-name-servers $DNS1, $DNS2;"/ /etc/dhcp/dhcpd.conf

#ADDRESS
sed -i "s/option routers.*/option routers $ADDRESS;"/ /etc/dhcp/dhcpd.conf

#REINICIA O SERVIÇO DHCP
sudo systemctl restart isc-dhcp-server
#INICIA O SERVIÇO ACCESS-POINT
sudo service hostapd start

#RETORNA PARA A PÁGINA INICIAL
echo '<html>'
echo '<head>'
echo '<meta http-equiv="refresh" content="0;url=hostapd-retorno.php">'
echo '</head>'
echo '</html>'

