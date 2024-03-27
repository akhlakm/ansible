#!/bin/bash
CHATID="{{ telegram.chat_ids }}"
TOKEN="{{ telegram.bot_token }}"

URL="https://api.telegram.org/bot$TOKEN/sendMessage"

TMPFILE="/tmp/ipinfotemp.txt"
IPLOGS="/home/{{ ansible_user }}/.iplogs.txt"

if [ -n "$SSH_CLIENT" ]; then
    dt=$(date '+%m/%d/%Y %H:%M:%S %Z')
    IP=$(echo $SSH_CLIENT | awk '{print $1}')
    HOSTNAME=$(hostname -f)
    IPADDR=$(hostname -I | awk '{print $1}')

    touch $IPLOGS

    if ! grep -q $IP $IPLOGS; then
        curl https://ipinfo.io/$IP -s -o $TMPFILE

        CITY=$(cat $TMPFILE | jq '.city' | sed 's/"//g')
        COUNTRY=$(cat $TMPFILE | jq '.country' | sed 's/"//g')
        TEXT="$dt - Login: ${USER} on $IPADDR ($HOSTNAME) from [$IP] $CITY, $COUNTRY."

        curl -s --max-time 10 -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null

        rm $TMPFILE
        echo "${TEXT}" >> $IPLOGS
    fi
fi
