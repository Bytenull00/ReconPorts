# ReconPorts

A simple and fast bash tool to list IP addresses for every known port.

Scans the following known ports: FTP, SSH, TELNET, HTTP, HTTPS, ORACLE, MSSQL, MYSQL, POSTGREST, AJP, TOMCAT, VNC
### Requirements

```
Nmap
```

### Installation

Installing nmap

```
sudo apt update
sudo apt install nmap -y
```

Install ReconPorts

```
git clone https://github.com/Bytenull00/ReconPorts.git
```

## Usage 
Ips range as input
```
[*] Usage: ./ReconPorts.sh -i 192.168.1.0-254
```
File with IPs as input
```
[*] Usage: ./ReconPorts.sh -f ips.txt
```

## Output

Create an output directory and generate the following files with the IP addresses for each known port.
```
[*] Saving results in ftp.txt 
[*] Saving results in ssh.txt 
[*] Saving results in http.txt 
[*] Saving results in mssql.txt 
[*] Saving results in oracle.txt 
[*] Saving results in mysql.txt 
[*] Saving results in postgresl.txt 
[*] Saving results in vnc.txt 
[*] Saving results in ajp.txt 
[*] Saving results in tomcat.txt 
```

### Credits 

* **Gsegundo**
