#!/bin/sh
# bot for ii
# apt-get install ii
## Arbre
#ii/
#└── irc.geeknode.net
#    ├── d
#    │   └── out
#    ├── in
#    ├── #ldn
#    │   ├── in
#    │   └── out
#    └── out

# Lancement et écoute sur le serveur geeknode.
/usr/bin/ii -i /home/seb/ii/ -s irc.geeknode.net -p 6667 -n sebot
# Connexion sur le chan ldn
echo "/j #ldn" > ii/irc.geeknode.net/in
# Envoi un message
echo "*** ii sucks !" > ii/irc.geeknode.net/#ldn/in
# Quit
echo "/quit ii sucks" > ii/irc.geeknode.net/in
