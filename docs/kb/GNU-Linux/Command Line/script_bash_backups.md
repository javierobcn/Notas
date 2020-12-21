# Script para realizar backups de la maquina local a un servidor SFTP

```bash

#!/bin/bash
#==============================================================================
#TITLE:            fullbackuplocal.sh
#DESCRIPTION:      script for automating the daily backup on my computer
#AUTHOR:           Javier
#DATE:             2020-12-20
#VERSION:          0.2
#USAGE:            ./fullbackuplocal.sh
#CRON:
  # example cron for daily backup @ 14:00 pm
  # min  hr mday month wday command
  # 0    14  *    *     *    /home/javier/Documentos/Programas/autoscripts/fullbackuplocal.sh


#==============================================================================
# CUSTOM SETTINGS
#==============================================================================

# File for Excluded files / folders for source backup
EXCLUDED_FILES='/home/javier/Documentos/Programas/autoscripts/exclusiones.txt'

#home directory path (Source for backup)
HOME_DIR='/home/javier/'

# directory to put the backup files
BACKUP_DIR="/home/javier/backups/"

#Numbers of days to keep backups files
NUMBER_OF_DAYS=30

# MYSQL Parameters
MYSQL_UNAME=root
MYSQL_PWORD=

# Don't backup databases with these names 
# Example: starts with mysql (^mysql) or ends with _schema (_schema$)
IGNORE_DB="(^mysql|_schema$)"

# include mysql and mysqldump binaries for cron bash user
PATH=$PATH:/usr/local/mysql/bin

#==============================================================================
# METHODS
#==============================================================================

# Append the date to name of backups files
BACKUP_DATE=`date +%d%b%y-%H_%M`


function delete_old_backups(){
  echo "Deleting $BACKUP_DIR*.gz older than $NUMBER_OF_DAYS days"
  find $BACKUP_DIR -type f -name "*.tar.gz" -mtime +$NUMBER_OF_DAYS -exec rm {} \;
}

function pg_database_list() {
  local databases=`sudo -u postgres psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`
  echo "$databases"
}

function backup_pg_database(){
    # Pending move here the logic for backup one database
    a=1
}

function backup_pg_databases(){
    local databases="$(pg_database_list)"
    for i in $databases; do
      if [ "$i" != "template0" ] && [ "$i" != "template1" ]; then
        echo Backing up $i to $BACKUP_DIR$i\_$BACKUP_DATE.gz
        sudo -u postgres pg_dump -Fc $i|gzip > $BACKUP_DIR$i\_$BACKUP_DATE.gz
      fi
    done
}

function backup_files(){
    # make a backup of home directory excluding files and folders specified in the txt file 
    # -z gzip files
    # -c create new tar file
    # -v verbose 
    # -p preserve permissions
    # -f name of the file to create / operate
    # -X specified files im txt file will not be included in the backup 
    echo "Executing: tar -X $EXCLUDED_FILES -zcvpf $BACKUP_DIR$BACKUP_DATE.tar.gz $HOME_DIR"
    tar -X $EXCLUDED_FILES -zcvpf $BACKUP_DIR$BACKUP_DATE.tar.gz $HOME_DIR
}

function hr(){
    printf '=%.0s' {1..100}
    printf "\n"
}

function backup_config(){
    mkdir /tmp/conf-bk-$(date +%Y%m%d)
    cd /tmp/conf-bk-$(date +%Y%m%d)

    #For General Configuration Files
    hostname > hostname.out
    cat /etc/issue > issue.out
    uname -a > uname.out
    uptime > uptime.out
    cat /etc/hosts > hosts.out
    /bin/df -h>df-h.out
    pvs > pvs.out
    vgs > vgs.out
    lvs > lvs.out
    /bin/ls -ltr /dev/mapper>mapper.out
    fdisk -l > fdisk.out
    cat /etc/fstab > fstab.out
    cat /etc/exports > exports.out
    cat /etc/crontab > crontab.out
    cat /etc/passwd > passwd.out
    ip link show > ip.out
    /bin/netstat -in>netstat-in.out
    /bin/netstat -rn>netstat-rn.out
    /sbin/ifconfig -a>ifconfig-a.out
    cat /etc/sysctl.conf > sysctl.out
    
    # Apache Sites
    # Pending --> cp /etc/apache2/sites-available/*.* 

    # Odoo Config
    # Odoo Logs+

    # Some System logs

    sleep 10s

    #Create a tar archive
    tar -cvf /tmp/$(hostname)-$(date +%Y%m%d.tar) /tmp/conf-bk-$(date +%Y%m%d)
    sleep 10s

    #Copy a tar archive to backup folder
    cp /tmp/$(hostname)-$(date +%Y%m%d.tar) $BACKUP_DIR

    #Remove the backup config folder
    cd ..
    rm -Rf conf-bk-$(date +%Y%m%d)
    rm $(hostname)-$(date +%Y%m%d.tar)
}

function mysql_login() {
    local mysql_login="-u $MYSQL_UNAME" 
    if [ -n "$MYSQL_PWORD" ]; then
        local mysql_login+=" -p$MYSQL_PWORD" 
    fi
    echo $mysql_login
}

function mysql_database_list() {
    local show_databases_sql="SHOW DATABASES WHERE \`Database\` NOT REGEXP '$IGNORE_DB'"
    echo $(mysql $(mysql_login) -e "$show_databases_sql"|awk -F " " '{if (NR!=1) print $1}')
}

function echo_status(){
    printf '\r'; 
    printf ' %0.s' {0..100} 
    printf '\r'; 
    printf "$1"'\r'
}

function backup_mysql_database(){
    backup_file="$BACKUP_DIR$BACKUP_DATE.$database.sql.gz" 
    output+="$database => $backup_file\n"
    echo_status "...backing up $count of $total databases: $database"
    $(mysqldump $(mysql_login) $database | gzip -9 > $backup_file)
}

function backup_mysql_databases(){
    local databases=$(mysql_database_list)
    local total=$(echo $databases | wc -w | xargs)
    local output=""
    local count=1
    for database in $databases; do
        backup_mysql_database
        local count=$((count+1))
    done
    echo -ne $output | column -t
}

function sync_files(){
    /usr/bin/rclone sync /home/javier/backups/ backs:/.local/maquinalocal
}


#==============================================================================
# RUN SCRIPT
#==============================================================================
delete_old_backups
hr
backup_pg_databases
hr
backup_mysql_databases
hr
backup_files
hr
backup_config
hr
sync_files

printf "All backed up!\n\n"

exit

```

## Ejemplo de fichero para exclusiones

Crear un fichero exclusiones.txt en la ruta que especifiques en la variable excluded_files del script



```text
/home/javier/backups/*
/home/javier/Descargas/*
/home/javier/Música/*
/home/javier/Vídeos/*
/home/javier/.cache/*
/home/javier/Documentos
/home/javier/.local/share/Trash/*
/home/javier/.local/share/Steam
/home/javier/.p2
/home/javier/VirtualBox VMs
/home/javier/.gconf/desktop
/home/javier/.rnd
/home/javier/.wine
/home/javier/.mozilla
```