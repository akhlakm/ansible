#!/bin/sh
CHATID="{{ telegram.chat_ids }}"
TOKEN="{{ telegram.bot_token }}"

URL="https://api.telegram.org/bot$TOKEN/sendMessage"

TMPFILE='/tmp/ipinfotemp.txt'

if [ -n "$SSH_CLIENT" ]; then
  IP=$(echo $SSH_CLIENT | awk '{print $1}')
  HOSTNAME=$(hostname -f)
  IPADDR=$(hostname -I | awk '{print $1}')
  curl https://ipinfo.io/$IP -s -o $TMPFILE

  CITY=$(cat $TMPFILE | jq '.city' | sed 's/"//g')
  COUNTRY=$(cat $TMPFILE | jq '.country' | sed 's/"//g')
  TEXT="Login as ${USER} on $IPADDR ($HOSTNAME) from $IP ($CITY, $COUNTRY)"

  curl -s --max-time 10 -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT" $URL > /dev/null

  rm $TMPFILE
fi
