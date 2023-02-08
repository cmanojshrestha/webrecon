#!/bin/bash

domain=$1

# Discover subdomains using amass

amass enum -d $domain -o subdomains.txt

# Check subdomains for live or dead

cat subdomains.txt | while read sub; do

  httpx $sub | grep -q "200 OK"

  if [ $? -eq 0 ]; then

    echo "$sub is live" >> live_subdomains.txt

  else

    echo "$sub is dead" >> dead_subdomains.txt

  fi

done

# Take screenshots of live subdomains

while read sub; do

  eyewitness --headless -f live_subdomains.txt --threads 100 --prepend-https

done < live_subdomains.txt

# Portscan top ports using masscan

masscan -p1-10000,80,443 $(cat live_subdomains.txt | sed 's/^/--adapter-port /') > ports.txt

# Dirbuster with common wordlist

dirbusting_wordlist="dirbusting_wordlist.txt"

while read sub; do

  dirbust --wordlist=$dirbusting_wordlist $sub

done < live_subdomains.txt

# Gitleaks search for leaks

gitleaks --repo-path=$domain --verbose

# Extract JavaScript files and search for API keys

cat live_subdomains.txt | while read sub; do

  curl -L $sub | grep -Eo "(http|https)://[a-zA-Z0-9./?=_-]*\.js" | while read js; do

    curl -L $js > "$sub.js"

    jminer "$sub.js"

  done

done

# Search in web archive

gau $domain > archive.txt

# Create HTML report

echo "<html><body><h1>Results for $domain</h1><h2>Live Subdomains</h2><ul>" >> report.html

while read sub; do

  echo "<li>$sub</li>" >> report.html

done < live_subdomains.txt

echo "</ul><h2>Dead Subdomains</h2><ul>" >> report.html

while read sub; do

  echo "<li>$sub</li>" >> report.html

done < dead_subdomains.txt

echo "</ul><h2>Ports</h2><pre>" >> report.html

cat ports.txt >> report.html

echo "</pre><h2>Web Archive</h2><pre>" >> report.html

cat archive.txt >> report.html

echo "</pre></body></html>" >> report.html

