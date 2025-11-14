#!/bin/bash

# This enumerates smpt users against a wordlist.

if [ $# -ne 2 ]; then
    echo "Usage: $0 <IP_SMTP> <wordlist>"
    exit 1
fi

SERVER="$1"
WORDLIST="$2"

while IFS= read -r user; do
    echo "VRFY $user" | nc -w 3 "$SERVER" 25 | grep -E "250|252" >/dev/null
    if [ $? -eq 0 ]; then
        echo "[+] User found: $user"
    else
        echo "[-] $user is not a valid user"
    fi
done < "$WORDLIST"
