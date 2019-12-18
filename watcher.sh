#!/bin/bash

function restartNecessaryMailcowContainers() {
    postfix_c=$(docker ps -qaf name=postfix-mailcow)
    dovecot_c=$(docker ps -qaf name=dovecot-mailcow)
    nginx_c=$(docker ps -qaf name=nginx-mailcow)
    docker restart ${postfix_c} ${dovecot_c} ${nginx_c}
}

function copyChangesToTemp() {
        cp /ssl-folder/cert.pem /temp/cert.pem
        cp /ssl-folder/key.pem /temp/key.pem
}

function checkForChanges() {
        echo "$(date) Checking certificate for changes"

        if [[ -f /ssl-folder/cert.pem && -f /ssl-folder/key.pem && -f /temp/cert.pem && -f /temp/key.pem ]];
        then
                if diff -q /temp/cert.pem /ssl-folder/cert.pem >/dev/null && diff -q /temp/key.pem /ssl-folder/key.pem >/dev/null ;
                then
                        echo "$(date) Certificate and key are still up to date, doing nothing"
                else
                        copyChangesToTemp
                        echo "$(date) Certificate or key differ, restarting necessary mailcow containers (postfix, dovecot and nginx)"
                        restartNecessaryMailcowContainers
                fi
        else
                if [[ -f /ssl-folder/cert.pem && -f /ssl-folder/key.pem ]];
                then
                        copyChangesToTemp
                        echo "$(date) Restarting necessary mailcow containers (postfix, dovecot and nginx) because the files for comparation did not exist"
                        restartNecessaryMailcowContainers
                else
                        echo "$(date) cert.pem or key.pem does not exists in the folder, please check your configuration!"
                fi
        fi
}

mkdir -p /temp

while true; do
        checkForChanges
		echo "$(date) Waiting for file changes..."
        inotifywait -qq /ssl-folder -e modify
        echo "($date) Detected file changes! - Waiting two seconds if any other file gets changed"
        # Wait 2 seconds, if other file(s) get changed
        sleep 2s
done