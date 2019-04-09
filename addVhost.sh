#!/bin/bash

##
##Creation des vhosts Apache
#Usage :
# ./addvhost vhost_name [use_ssl]
##

#Définir le répertoire de création du dossier racine Apache
ROOT_DIR="/home/www/"

if [ $# == 0 ]
then
	echo "To few arguments to process. Operation failed"
	exit -1
else

	# Copier le fichier template-symfony vers /etc/apache2/sites-available
	#avec le nom vhost_name.conf

	cp ./template-symfony /etc/apache2/sites-available/$1.conf

	#Créer le dossier web dans le dossier ROOT_DIR
	mkdir -p  $ROOT_DIR$1/web

	#Remplacer "template" par "vhost_name"dans le fichier de configuration
	sed -i 's/template/'$1'/g' /etc/apache2/sites-available/$1.conf

	# Ajouter le fichier de configuration à la liste des sites actifs
	a2ensite $1.conf

	# Mettre à jour le fichier hosts
	echo "10.31.99.60 $1.wrk www.$1.wrk" >> /etc/hosts

	#Vérifier l'execution globale
	touch $ROOT_DIR$1/web/app.php
	echo "<?php phpinfo();" >> $ROOT_DIR$1/web/app.php

	# Relancer Apache
	systemctl restart apache2.service
fi
