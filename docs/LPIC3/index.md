#Material curs LPIC 3-303

## Enlaces sobre los exámenes:
- [Resumen de las certificaciones](http://www.lpi.org/our-certifications/summary-of-certifications)
- [Resumen de la certificación LPIC-3 (303)](https://www.lpi.org/our-certifications/lpic-3-303-overview)
- [Lo que hace falta saber para superar el examen 303](https://www.lpi.org/our-certifications/exam-303-objectives)

##Recursos para descargar:
- [Fedora Workstation](https://getfedora.org/es/workstation/download/)
- [Virtual Box Image Fedora](https://www.osboxes.org/fedora/)
- Màquina servidora LDAP+Kerberos+NFS4 ja funcional
- Màquina client SSSD ja funcional
- Arxiu ldif amb usuaris de mostra


##Documentos del curso
###1.Previos
- [Comandos básicos de red en Linux](1-Previos/Comandos básicos de red en Linux)
- [Teoria básica sobre LDAP y NSS](1-Previos/Autenticación e Identificación de usuarios con LDAP) 
- [Teoria básica sobre NFS](1-Previos/Compartir ficheros con NFSv4)
- Gestió básica de mòduls del kernel
- Journald i journalctl
- [Systemd](1-Previos/Systemd)
- Breu descripció de /proc i de /sys
- Comanda Jq (per l'eve.json de Suricata, Beats de l'ELK, etc)
- D-Bus (IPC per Firewalld, Systemd,...)
- Servidor Apache (HTTP)


###Autenticació-Autorització:
- Introducción
- Autenticación vs Autorización
- Hashes i endevinació de contrasenyes. Keyloggers

### Módulos PAM
- PAM i mòduls interessants (pam_limit, pam_pwquality, etc) (Pes 3)
- Client Kerberos+LDAP i FreeIPA (NSS+PAM+SSSD)
- Instal.lació servidor 389DS
- Administració básica d'un directori 389DS
- Autenticació i identificació contra servidor 389DS fent servir SSSD(Pes 5)
- Instal.lació i configuració d'un servidor MIT Kerberos i cooperació amb servidors LDAP i NFS(Pes 5)PENDENT NFS
- FreeIPA (client, servidor i rèplica)(Pes 4)PENDENT

###Frameworks d'autorització
- Su i sudo
- Polkit

### ACLs, Capabilities y atributos extendidos
- Bits suid,sgid,sticky
- Capabilities i atributs extesos(Pes 3)
- ACLs(Pes 3)

### SELinux
- SELinux(Pes 4)

### RADIUS
- RADIUS(Pes 4)

### Chroot y otros "bichos": namespaces, cgroups, OS/App containers
- Intro contenedores(Pes 3)
- Ejemplo práctico: contenidors mkosi/machinectl(Pes 3)

###Monitorització local:
- Captura de crides al sistema (i altres events)
- Strace, Ltrace i llibreries
- Sysdig i Falco
- Audit(Pes 4)
- Altres FIMs
- ELK (amb Falco i Audit)

###Detectors de rootkits i malware
- Lynis, OpenSCAP, Rkhunter, Maldet, Aide (Pes 4)
- Ansible (com a mètode per aplicar de forma automàtica els canvis de configuració suggerits pels programes anteriors)
- Honeypots (com a mètode de captura i estudi de malware)
- Metasploit (eina per crear "malware" ad-hoc i introduir-lo a víctimes fent servir algun exploit)
- Yara (eina per crear definicions pròpies de detecció de malware) PENDENT


###Hardering local:
- Encriptació de disc amb LUKS i de sistemes de fitxers amb Ecryptfs (Pes 3)
- Encriptació de fitxers amb GPG
- Contrasenyes arranc al gestor Grub (Pes 3)
- Sysctl (Pes 3)
- Udev "i bad usbs"


###Monitorització de xarxa:
- Inspecció en brut del tràfic de xarxa i generació d'alertes
- Breu descripció del protocol TCP
- Wireshark(Pes 4)
- NIDS Snort/Suricata (Pes 4)
- Constructor de paquets Scapy

###Recol.lectors d'informació estadística sobre el tràfic de xarxa
- Eines TSBD
- Netflow i IPFIX
- Monitorització d'ample de banda amb Cacti (Pes 4) PENDENT

###Hardering de xarxa i servidors:
- Tallafocs
- Tallafocs Netfilter (NFTables) (Pes 5)
- Tallafocs Firewalld

###Vulnerabilitats
- Introducció a les vulnerabilitats (web)
- Detector de vulnerabilitats OpenVAS (Pes 4)PENDENT
- Detector de vulnerabilitat Nmap (Pes 4)
- Detector de vulnerabilitats ZAP

###Criptografia pràctica amb OpenSSL
- Conceptes de criptografia (Pes 5)
- Xuleta comandes OpenSSL(Pes 5)PENDENT

###Securització d'un servidor Apache
- Implementació servidor Apache segur (HTTPS)(Pes 4)
- DNSSEC
- NFS i CIFS segurs
- VPNs amb OpenVPN i IPSec


###Llibres:
- [Llibre PacktPub](Libros/SeguridadLinux.pdf)