#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Usage: $0 <IP_SMTP> <wordlist> [timeout] [delay]"
    echo "  timeout = Netcat timeout threashold (default: 6s)"
    echo "  delay   = request delay (default: 0.2s)"
    exit 1
fi

SERVER="$1"
WORDLIST="$2"
TIMEOUT="${3:-6}"    # default timeoutt: 6 seconds
DELAY="${4:-0.2}"    # default delayt: 0.2 seconds

# ANSI colors
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m"

while IFS= read -r user; do
    
    RESPONSE=$(echo "VRFY $user" | nc -w "$TIMEOUT" "$SERVER" 25 2>/dev/null)

    if echo "$RESPONSE" | grep -E "250|252" >/dev/null; then
        echo -e "${GREEN}[+] User found: $user${RESET}"
    elif echo "$RESPONSE" | grep -q "550"; then
        echo -e "${RED}[-] $user not found${RESET}"
    else
        echo -e "${YELLOW}[?] No response or timeout for: $user${RESET}"
    fi

    sleep "$DELAY"

done < "$WORDLIST"
