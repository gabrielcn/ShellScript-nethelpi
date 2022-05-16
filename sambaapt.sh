#!/bin/bash
echo "content-type: text/html"
echo

read VAR

sudo apt install samba

sudo apt update

sudo apt upgrade

echo '<html>'
echo '<head>'
echo '<meta http-equiv="refresh" content="0;url=samba-retorno.php">'
echo '</head>'
echo '</html>'

