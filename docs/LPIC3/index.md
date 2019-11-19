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
- [Gestió básica de mòduls del kernel](https://q2dg.github.io/LPIC3-303/ModulsKernel.pdf)
- [Journald i journalctl](https://q2dg.github.io/LPIC3-303/Journalctl.pdf)
- [Systemd](../LPIC1/Systemd.md)
- Breve descripción de [/proc](https://www.thegeekdiary.com/understanding-the-proc-file-system) y de [/sys](https://www.thegeekdiary.com/understanding-the-sysfs-file-system-in-linux/)
- [Comanda Jq](https://q2dg.github.io/LPIC3-303/Jq.pdf) (per l'eve.json de Suricata, Beats de l'ELK, etc)
- [D-Bus](https://q2dg.github.io/LPIC3-303/DBus.pdf) (IPC per Firewalld, Systemd,...)
- [Servidor HTTP Apache ](https://q2dg.github.io/LPIC3-303/ServidorApache(HTTP).pdf)

###2.Autenticació-Autorització:
- [Autenticación vs Autorización](2-Autenticación-Autorización/Autenticación_vs_Autorización)
- [Hashes i endevinació de contrasenyes. Keyloggers](https://q2dg.github.io/LPIC3-303/HashesContrasenyesiKeyloggers.pdf)

###3.Módulos PAM
- [PAM i mòduls interessants, (pam_limit, pam_pwquality, etc) (Pes 3)](3.Módulos PAM/PAM) 

###4.Client Kerberos+LDAP i FreeIPA (NSS+PAM+SSSD)
- [Instal.lació servidor 389DS](https://q2dg.github.io/LPIC3-303/LDAP-Kerberos-FreeIPA/PracticaInstalacion389DS.pdf)
- [Administración básica de un directorio 389DS](https://q2dg.github.io/LPIC3-303/LDAP-Kerberos-FreeIPA/PracticaAdministracionBasicaDirectorio.pdf)
- Autenticació i identificació contra servidor 389DS fent servir SSSD(Pes 5)
- Instal.lació i configuració d'un servidor MIT Kerberos i cooperació amb servidors LDAP i NFS(Pes 5)PENDENT NFS
- FreeIPA (client, servidor i rèplica)(Pes 4)PENDENT

###5.Frameworks d'autorització
- Su i sudo
- Polkit

###6.ACLs, Capabilities y atributos extendidos
- Bits suid,sgid,sticky
- Capabilities i atributs extesos(Pes 3)
- ACLs(Pes 3)

###7.SELinux
- SELinux(Pes 4)

###8.RADIUS
- RADIUS(Pes 4)

###9.Chroot y otros "bichos": namespaces, cgroups, OS/App containers
- Intro contenedores(Pes 3)
- Ejemplo práctico: contenidors mkosi/machinectl(Pes 3)

###10.Monitorització local:
- Captura de crides al sistema (i altres events)
- Strace, Ltrace i llibreries
- Sysdig i Falco
- Audit(Pes 4)
- Altres FIMs
- ELK (amb Falco i Audit)

###11.Detectors de rootkits i malware
- Lynis, OpenSCAP, Rkhunter, Maldet, Aide (Pes 4)
- Ansible (com a mètode per aplicar de forma automàtica els canvis de configuració suggerits pels programes anteriors)
- Honeypots (com a mètode de captura i estudi de malware)
- Metasploit (eina per crear "malware" ad-hoc i introduir-lo a víctimes fent servir algun exploit)
- Yara (eina per crear definicions pròpies de detecció de malware) PENDENT


###12.Hardering local:
- Encriptació de disc amb LUKS i de sistemes de fitxers amb Ecryptfs (Pes 3)
- Encriptació de fitxers amb GPG
- Contrasenyes arranc al gestor Grub (Pes 3)
- Sysctl (Pes 3)
- Udev "i bad usbs"


###13.Monitorització de xarxa:
- Inspecció en brut del tràfic de xarxa i generació d'alertes
- Breu descripció del protocol TCP
- Wireshark(Pes 4)
- NIDS Snort/Suricata (Pes 4)
- Constructor de paquets Scapy

###14.Recol.lectors d'informació estadística sobre el tràfic de xarxa
- Eines TSBD
- Netflow i IPFIX
- Monitorització d'ample de banda amb Cacti (Pes 4) PENDENT

###15.Hardering de xarxa i servidors:
- Tallafocs
- Tallafocs Netfilter (NFTables) (Pes 5)
- Tallafocs Firewalld

###16.Vulnerabilitats
- Introducció a les vulnerabilitats (web)
- Detector de vulnerabilitats OpenVAS (Pes 4)PENDENT
- Detector de vulnerabilitat Nmap (Pes 4)
- Detector de vulnerabilitats ZAP

###17.Criptografia pràctica amb OpenSSL
- Conceptes de criptografia (Pes 5)
- Xuleta comandes OpenSSL(Pes 5)PENDENT

###18.Securització d'un servidor Apache
- Implementació servidor Apache segur (HTTPS)(Pes 4)
- DNSSEC
- NFS i CIFS segurs
- VPNs amb OpenVPN i IPSec

###19.Llibres:
- [Llibre PacktPub](Libros/SeguridadLinux.pdf)