#!/bin/bash

DOMAIN="weighted-routing-test.domain.co.kr"
DNS_SERVER="8.8.8.8"
REQUEST_COUNT=100

IP_COUNT_FILE="/tmp/ip_count.txt"
> "$IP_COUNT_FILE"

for (( i=1; i<=REQUEST_COUNT; i++ ))
do
    IP=$(dig +short @$DNS_SERVER $DOMAIN | head -n 1)

    if [[ ! -z "$IP" ]]; then
        if ! grep -q "$IP" "$IP_COUNT_FILE"; then
            echo "$IP 0" >> "$IP_COUNT_FILE"
        fi
        awk -v ip="$IP" '$1 == ip { $2++; print; next } 1' "$IP_COUNT_FILE" > "${IP_COUNT_FILE}.tmp" && mv "${IP_COUNT_FILE}.tmp" "$IP_COUNT_FILE"

        IP_COUNT=$(awk -v ip="$IP" '$1 == ip { print $2 }' "$IP_COUNT_FILE")

        RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -H "Host: $DOMAIN" http://"$IP"/weighted-routing)
        echo "Request #$i to $IP: HTTP Status Code $RESPONSE (IP: ${IP_COUNT}번)"
    else
        echo "DNS lookup failed."
    fi

    sleep 1
done
