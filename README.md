### webrecon

This is a bash script that performs reconnaissance on a domain. It checks if various tools such as amass, httpx, eyewitness, masscan, dirbust, gitleaks, gau, and jminer are installed. If any of these tools are not installed, the script will exit and display an error message. The script performs the following tasks on the domain:

Discover subdomains using amass and store them in a file.
Check if subdomains are live or dead.
Take screenshots of live subdomains using eyewitness.
Port scan top ports on live subdomains using masscan.
Dir bust live subdomains using a common wordlist.
Search for leaks using gitleaks.


