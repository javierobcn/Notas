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
excluded_files='/home/javier/Documentos/Programas/autoscripts/exclusiones.txt'

#home directory path (Source for backup)
home_dir='/home/javier/'

# directory to put the backup files
backup_dir="/home/javier/backups/"

#Numbers of days to keep backups files
number_of_days=30

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
backup_date=`date +%d%b%y-%H_%M`


function delete_old_backups(){
  echo "Deleting $backup_dir*.tar.gz older than $number_of_days days"
  find $backup_dir -type f -name "*.tar.gz" -mtime +$number_of_days -exec rm {} \;
}

function pg_database_list() {
  local databases=`sudo -u postgres psql -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d'`
  echo "$databases"
}

function backup_pg_database(){
    a=1
}

function backup_pg_databases(){
    local databases="$(pg_database_list)"
    for i in $databases; do
      if [ "$i" != "template0" ] && [ "$i" != "template1" ]; then
        echo Backing up $i to $backup_dir$i\_$backup_date.gz
        sudo -u postgres pg_dump -Fc $i|gzip > $backup_dir$i\_$backup_date.gz
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
    echo "Executing3: tar -X $excluded_files -zcvpf $backup_dir$backup_date.tar.gz $home_dir"
    tar -X $excluded_files -zcvpf $backup_dir$backup_date.tar.gz $home_dir
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
    
    sleep 10s

    #Create a tar archive
    tar -cvf /tmp/$(hostname)-$(date +%Y%m%d.tar) /tmp/conf-bk-$(date +%Y%m%d)
    sleep 10s

    #Copy a tar archive to backup folder
    cp /tmp/$(hostname)-$(date +%Y%m%d.tar) $backup_dir

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
    backup_file="$backup_dir$backup_date.$database.sql.gz" 
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