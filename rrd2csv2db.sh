# File location & Nmae:  /root/Scripts/nagio2Db.sh
#/usr/bin/bash
echo "Script to generate CSV from RRD files --Started"
cp -R /usr/local/pnp4nagios/var/perfdata/ /home/nagiuser/RRD_Files/

>/home/nagiuser/Datafiles/Total.csv
>/home/nagiuser/Datafiles/Fnl.csv
>/var/lib/mysql-files/Fnl.csv
>/var/lib/mysql-files/Fnl1.csv

>/home/nagiuser/Datafiles/10.45.4.253,RootDiskUtil
>/home/nagiuser/Datafiles/10.45.4.253,CPU
>/home/nagiuser/Datafiles/10.45.4.253,PING
>/home/nagiuser/Datafiles/10.45.4.253,Mem

perl /home/nagiuser/nagiScripts/NewRrd2Csv.pl --end -3600 /home/nagiuser/RRD_Files/perfdata/OSM_10.45.4.253/RootDiskUsage.rrd >>/home/nagiuser/Datafiles/10.45.4.253,RootDiskUtil
awk -F, 'NR==1{print "file_name",$0;next}{print FILENAME"," , $0}' /home/nagiuser/Datafiles/10.45.4.253,RootDiskUtil >>/home/nagiuser/Datafiles/Total.csv

perl /home/nagiuser/nagiScripts/NewRrd2Csv.pl --end -3600 /home/nagiuser/RRD_Files/perfdata/OSM_10.45.4.253/CPU-Check.rrd >>/home/nagiuser/Datafiles/10.45.4.253,CPU
awk -F, 'NR==1{print "file_name",$0;next}{print FILENAME"," , $0}' /home/nagiuser/Datafiles/10.45.4.253,CPU >>/home/nagiuser/Datafiles/Total.csv

perl /home/nagiuser/nagiScripts/NewRrd2Csv.pl --end -3600 /home/nagiuser/RRD_Files/perfdata/OSM_10.45.4.253/PING.rrd >>/home/nagiuser/Datafiles/10.45.4.253,PING
awk -F, 'NR==1{print "file_name",$0;next}{print FILENAME"," , $0}' /home/nagiuser/Datafiles/10.45.4.253,PING >>/home/nagiuser/Datafiles/Total.csv

perl /home/nagiuser/nagiScripts/NewRrd2Csv.pl --end -3600 /home/nagiuser/RRD_Files/perfdata/OSM_10.45.4.253/Mem-Check.rrd >>/home/nagiuser/Datafiles/10.45.4.253,Mem
awk -F, 'NR==1{print "file_name",$0;next}{print FILENAME"," , $0}' /home/nagiuser/Datafiles/10.45.4.253,Mem >>/home/nagiuser/Datafiles/Total.csv

awk -F  ',' 'BEGIN {print "IP,Desc,Time,Metric,Value"}
        /10.45.4.253/ {Time=$3}
        /10.45.4.253/ {Mtrc=$2}
        /10.45.4.253/ {value=$4; print "10.45.4.253", "," , "NA," ,Time, "," ,Mtrc, "," ,value}' /home/nagiuser/Datafiles/Total.csv >>/home/nagiuser/Datafiles/Fnl.csv

cp /home/nagiuser/Datafiles/Fnl.csv /var/lib/mysql-files/Fnl.csv

#grep -v "file_name RESOLUTION: 1" /var/lib/mysql-files/Fnl.csv >>/var/lib/mysql-files/Fnl1.csv

#mysql_config_editor set --login-path=local --host=localhost --user=root --p=password


MYSQL_PWD=password mysql -u root -e "LOAD DATA     INFILE '/var/lib/mysql-files/Fnl.csv'
    INTO TABLE nagiosdb.OSM_Server_Metrics
    COLUMNS TERMINATED BY ','
    LINES TERMINATED BY '\n'
    IGNORE 1 ROWS;"

