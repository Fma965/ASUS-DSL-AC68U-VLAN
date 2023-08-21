#!/bin/sh

discord_webhook() {
    webhook="https://discord.com/api/webhooks/[WEBHOOK]"
    discordEmbed="{\"content\":\"\",\"embeds\":[{\"color\": ${3}, \"type\":\"rich\",\"title\":\"${1}\",\"fields\":[{\"name\":\"Server\",\"value\":\"${2}\"},{\"name\":\"Service URL\",\"value\":\"${4}\"}]}]}"
    curl -si -o /dev/null -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "${discordEmbed}" "${webhook}"    
} 

# Proxmox
url="https://192.168.1.2:8006/"
server="F9-Apps"
downfile="/tmp/$server.tmp"
response=$(curl -w "%{http_code}\n" -sIk -o /dev/null --connect-timeout 10 -m 10 ${url})
if [[ "${response}" = '501' ]] && [[ -e "${downfile}" ]]; then
    discord_webhook "✅ Your service $server is up! ✅" $server 5763719 $url
    rm $downfile
elif [[ "${response}" != '501' ]]; then
    discord_webhook "❌ Your service $server went down. ❌" $server 16711680 $url
    touch $downfile
fi

# Unraid
url="http://192.168.1.3/login"
server="F9-NAS"
downfile="/tmp/$server.tmp"
response=$(curl -w "%{http_code}\n" -sI -o /dev/null --connect-timeout 10 -m 10 ${url})
if [[ "${response}" = '200' ]] && [[ -e "${downfile}" ]]; then
    discord_webhook "✅ Your service $server is up! ✅" $server 5763719 $url
    rm $downfile
elif [[ "${response}" != '200' ]]; then
    discord_webhook "❌ Your service $server went down. ❌" $server 16711680 $url
    touch $downfile
fi

# Home Assistant
url="http://192.168.1.4:8123"
server="F9-Home"
downfile="/tmp/$server.tmp"
response=$(curl -w "%{http_code}\n" -sI -o /dev/null --connect-timeout 10 -m 10 ${url})
if [[ "${response}" = '405' ]] && [[ -e "${downfile}" ]]; then
    discord_webhook "✅ Your service $server is up! ✅" $server 5763719 $url
    rm $downfile
elif [[ "${response}" != '405' ]]; then
    discord_webhook "❌ Your service $server went down. ❌" $server 16711680 $url
    touch $downfile
fi

# RDP
url="http://192.168.1.12"
server="F9-RDP"
downfile="/tmp/$server.tmp"
response=$(curl -w "%{http_code}\n" -sI -o /dev/null --connect-timeout 10 -m 10 ${url})
if [[ "${response}" = '200' ]] && [[ -e "${downfile}" ]]; then
    discord_webhook "✅ Your service $server is up! ✅" $server 5763719 $url
    rm $downfile
elif [[ "${response}" != '200' ]]; then
    discord_webhook "❌ Your service $server went down. ❌" $server 16711680 $url
    touch $downfile
fi
