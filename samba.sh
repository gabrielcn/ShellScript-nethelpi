#!/bin/bash
echo "content-type: text/html"
echo
read TRIPA

ARQ=$(echo "$TRIPA" | cut -d'&' -f1 | cut -d'&' -f2 | cut -d'=' -f2 | tr '+' ' ')

COMMENT=$(echo "$TRIPA" | cut -d'&' -f2 | cut -d'=' -f2 | cut -d'=' -f2 | tr '+' ' ')

CAMIN=$(echo "$TRIPA" | cut -d'&' -f3 | cut -d'=' -f2 | tr '%2F' '/' | tr -s '///')

USER=$(echo "$TRIPA" | cut -d'&' -f4 | cut -d'=' -f2)

USERSENHA=$(echo "$TRIPA" | cut -d'&' -f6 | cut -d'=' -f2)

sudo useradd $USER

sudo echo -e "$USERSENHA\n$USERSENHA" | sudo smbpasswd -a $USER

chmod 777 /home

sudo mkdir "$CAMIN"

echo "
[$ARQ]
comment = $COMMENT
path = $CAMIN
valid users = $USER
writeable = yes
" >> /etc/samba/smb.conf

systemctl restart smbd

echo '<html>'
echo '<head>'
echo '<meta http-equiv="refresh" content="0;url=samba-retorno.php">' 
echo '</head>'
echo '</html>'
