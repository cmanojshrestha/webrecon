
### Enumerates subdomains using amass


Enumerates subdomains using amass and outputs the result to a file named "subdomains.txt".

Reads each subdomain in "subdomains.txt" and performs a check to see if the subdomain is live or dead by sending an HTTP request with httpx. The result of the check is then added to either "live_subdomains.txt" or "dead_subdomains.txt".

For each subdomain in "live_subdomains.txt", a screenshot is taken using eyewitness.

Performs a port scan on the top ports of the live subdomains using masscan and outputs the result to a file named "ports.txt".

Performs directory brute-forcing on the live subdomains using dirbust and a wordlist named "dirbusting_wordlist.txt".

Searches for any leaked information in the repository using gitleaks.

For each subdomain in "live_subdomains.txt", the script extracts JavaScript files and searches for API keys using curl and jminer.

Searches for archived information using gau and outputs the result to a file named "archive.txt".

Generates an HTML report that includes the list of live and dead subdomains, port scan results, and archive information.

There doesn't seem to be any syntax errors or issues that would prevent the script from running. However, it's important to note that some of the tools used in the script (amass, httpx, eyewitness, masscan, dirbust, gitleaks, and gau) may not be installed on your system, and will need to be installed before you can run the script.



