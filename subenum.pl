#!/bin/bash

# Add your name
Author="Manoj Shrestha"

# Check if domain name is provided as command line argument
if [ $# -eq 0 ]; then
  echo "Please provide a domain name as argument"
  echo "Example: $0 example.com"
  exit 1
fi

domain=$1

# Check if amass is installed
if ! command -v amass &> /dev/null
then
  echo "Amass is not installed, please install it"
  exit 1
fi

# Check if httpx is installed
if ! command -v httpx &> /dev/null
then
  echo "Httpx is not installed, please install it"
  exit 1
fi

# Check if eyewitness is installed
if ! command -v eyewitness &> /dev/null
then
  echo "Eyewitness is not installed, please install it"
  exit 1
fi

# Check if masscan is installed
if ! command -v masscan &> /dev/null
then
  echo "Masscan is not installed, please install it"
  exit 1
fi

# Check if dirbust is installed
if ! command -v dirbust &> /dev/null
then
  echo "Dirbust is not installed, please install it"
  exit 1
fi

# Check if gitleaks is installed
if ! command -v gitleaks &> /dev/null
then
  echo "Gitleaks is not installed, please install it"
  exit 1
fi

# Check if gau is installed
if ! command -v gau &> /dev/null
then
  echo "Gau is not installed, please install it"
  exit 1
fi

# Check if jminer is installed
if ! command -v jminer &> /dev/null
then
  echo "Jminer is not installed, please install it"
  exit 1
fi

echo "Discovering subdomains using amass..."
amass enum -d $domain -o subdomains.txt

echo "Checking subdomains for live or dead..."
cat subdomains.txt | while read sub; do
  httpx $sub | grep -q "200 OK"
  if [ $? -eq 0 ]; then
    echo "$sub is live" >> live_subdomains.txt
  else
    echo "$sub is dead" >> dead_subdomains.txt
  fi
done

echo "Taking screenshots of live subdomains..."
while read sub; do
  eyewitness --headless -f live_subdomains.txt --threads 100 --prepend-https
done < live_subdomains.txt

echo "Portscanning top ports using masscan..."
masscan -p1-10000,80,443 $(cat live_subdomains.txt | sed 's/^/--adapter-port /') > ports.txt

echo "Dirbusting with common wordlist..."
dirbusting_wordlist="dirbusting_wordlist.txt"
while read sub; do
  dirbust --wordlist=$dirbusting_wordlist $sub
done < live_subdomains.txt

echo "Searching for leaks using gitleaks..."
gitleaks --repo-path=$
