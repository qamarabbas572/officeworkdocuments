#no_of_running_web_container=$(docker ps |grep web-server* |wc -l)
#echo $no_of_running_web_container

########################  Getting Information From User ######################
#running_web_ports_to_file=$(docker container ls --format "table {{.Ports}}" -a | grep -v "^$" | grep "80/tcp" | cut -d ':' -f2 | cut -d '-' -f1 |sort -n > /root/docker_compose_script/missingno)

#echo ${running_web_ports_to_file}

#missing_web_port=$(awk '{for(i=p+801; i<$1; i++) print i} {p=$1}' /root/docker_compose_script/missingno)

#echo ${missing_web_port}

#useable command

####### Scripts for web ports

#web_running_ports=$(docker container ls --format "table {{.Ports}}" -a | grep -v "^$" | grep "80/tcp" | cut -d ':' -f2 | cut -d '-' -f1 |sort -n)
#echo -e "These are the running web ports: \\n$web_running_ports "



################## New Code ==================

#================================================================================================================================================
#============================================ Scripts for web ports ================================

#web_running_ports=$(docker container ls --format "table {{.Ports}}" -a | grep -v "^$" | grep "80/tcp" | cut -d ':' -f4 | cut -d '-' -f3 |sort -n)
web_server_occupied_ports=$(docker ps -a --format "{{.Ports}}" -a | grep -v "^$" | grep "80/tcp" | cut -d ':' -f6 | cut -d '-' -f1 |sort -n)

# To send ports in ports.txt
echo -e "$web_server_occupied_ports\\n " > ports.txt
# To show the number of ports
echo -e "These are the running web ports: \\n$web_server_occupied_ports "

#====================================================================================================
#============================================= SSH Ports ============================================

web_occupied_ssh_ports=$(docker ps -a --format "{{.Ports}}" -a | grep -v "^$" | grep "80/tcp" | cut -d ':' -f2 | cut -d '-' -f1 |sort -n)
# To send ssh ports in sshports.txt
echo -e "$web_occupied_ssh_ports\\n " > sshports.txt

#================================================================================================================================================

#================================================== To Show number of SSh Ports =================================================================

echo -e "These are the already occupied web container ssh ports: \\n$web_occupied_ssh_ports "

#================================================== Script for Auto Port Assignment ============================================================
#================================================== Port 80 ====================================================================================
sort ports.txt > sorted_ports.txt

min=$(comm -13 sorted_ports.txt <(seq 801 899) | head -1)

#echo "$min"

echo $min >> ports.txt

grep -v "$1" ports.txt > tmpfile && mv -f tmpfile ports.txt
#echo "$1 Port removed"

#============================================================================================================
# ================================================ Port 443 =================================================

#web_server_occupied_ssl_ports=$(docker ps -a --format "{{.Ports}}" -a | grep -v "^$" | grep "80/tcp" | cut -d ':' -f10 | cut -d '-' -f1 |sort -n)
#echo -e "$web_server_occupied_ssl_ports\\n " > sslports.txt
#echo -e "These are the running ssl web ports: \\n$web_server_occupied_ssl_ports "

#sort sslports.txt > sslsorted_ports.txt

#sslmin=$(comm -13 sslsorted_ports.txt <(seq 44301 44399) | head -1)

##echo "$sshmin"

#echo $sslmin >> sslports.txt

#grep -v "$1" sslports.txt > ssltmpfile && mv -f ssltmpfile sslports.txt


#=====================================================
#=============== SSH Port Section ====================6

sort sshports.txt > sshsorted_ports.txt

sshmin=$(comm -13 sshsorted_ports.txt <(seq 2201 2299) | head -1)

#echo "$sshmin"

echo $sshmin >> sshports.txt

grep -v "$1" sshports.txt > sshtmpfile && mv -f sshtmpfile sshports.txt
#echo "$1 Port removed"



#############33## End New Code ================






#array=$(echo ${web_running_ports})



#echo $array

#arr=($array)

#array=$(echo $abc)
#for (( i = 0 ; i < $((${#arr[@]}-1)) ; i++ )); do
#if [ $((${arr[$i]}+1)) -ne ${arr[$(($i + 1))]} ] ;then
#    available_web_port="$((${arr[$i]}+1))"
#    break
#fi
#done

#echo $available_web_port

############ End Scripts for web ports


#available_web_port=$(echo ${missing_web_port} | awk '{print $1}')

#echo ${available_web_port}

echo "Enter Docker composer File Version e.g. 2, 3 or 3.3 etc: "
read  docker_composer_file_ver

echo "Enter Web Port: e.g. 801, 802, 803 for 3rd web instance Container "
available_web_port=$min
echo "$available_web_port"

echo "Enter Web container SSH Port 2201, 2222, 2299"
apache_ssh_port=$sshmin
echo "$apache_ssh_port"

#echo "Enter Web container SSL Port 44301, 44302, 44399"
#apache_ssl_port=$sslmin
#echo "$apache_ssl_port"

#echo "Enter Elastic Search Port which you want to map e.g. 9202, 9203 ... 9299 "
#read es_port_map

echo "Enter your instance name: e.g. XYX-ABC Note: Don't use Space "
read instance_name

echo "Enter your web container root password "
read web_container_root_password

###########################  Start Switch Case Section #########################

# Case For Web Docker Hub URL Selection
echo "Enter the name of web php container  [Enter 1 for => web-php56], [Enter 2 for => web-php71], [Enter 3 for => web-php73]: "
read webphp_image_url
case $webphp_image_url in
   1)
        web_image_url="rtitsupport/ubuntu1804:webphp56-V1"
        ;;
   2)
        web_image_url="rtitsupport/ubuntu1804:webphp71-V1"
        ;;
   3)
        web_image_url="rtitsupport/ubuntu1804:webphp73-V1"
        ;;
esac

# Case For Mysql Docker Hub URL Selection
echo "Enter the name of mysql container Image URL  [Enter 1 for => mysql56], [Enter 2 for => mysql57], [Enter 3 for => mysql8]: "
read mysql_url
case $mysql_url in
   1)
        mysql_image_url="rtitsupport/ubuntu1804:mysql56-V1"
        ;;
   2)
        mysql_image_url="rtitsupport/ubuntu1804:mysql57-V1"
        ;;
   3)
        mysql_image_url="rtitsupport/ubuntu1804:mysql8-V1"
        ;;
esac

# Case For ElasticSearch Docker Hub URL Selection
echo "Enter the name of mysql container Image URL  [Enter 1 for => Elasticsearch 1.7.x], [Enter 2 for => Elasticsearch 5.4.x], [Enter 3 for => Elasticsearch 6.2.x]: "
read elasticsearch_url
case $elasticsearch_url in
   1)
        es_image_url="rtitsupport/ubuntu1804:es175-V1"
        ;;
   2)
        es_image_url="rtitsupport/ubuntu1804:es540-V1"
        ;;
   3)
        es_image_url="rtitsupport/ubuntu1804:es620-V1"
        ;;
esac

mkdir /opt/instance_yml/$instance_name
mkdir /opt/instance_yml/$instance_name/mysql
mkdir /opt/instance_yml/$instance_name/elasticsearch
#################################### End Switch Case Section #########################


#################################### Start If Else Section   #########################

#For Web Container Name End Part e.g. web-server-php71
if [ "$webphp_image_url" == "1" ]; then
   web_container_name_part="php56"

elif [ "$webphp_image_url" == "2" ]; then
   web_container_name_part="php71"

else [ "$webphp_image_url" == "3" ]
   web_container_name_part="php73"
fi

#For MySQL Container Name End Part e.g. mysql-57
if [ "$mysql_url" == "1" ]; then
   mysql_container_name_part="mysql56"

elif [ "$mysql_url" == "2" ]; then
   mysql_container_name_part="mysql57"

else [ "$mysql_url" == "3" ]
   mysql_container_name_part="mysql8"
fi

#For Elasticsearch Container Name End Part e.g. elasticsearch-5.4.x
if [ "$elasticsearch_url" == "1" ]; then
   es_container_name_part="ES-1-7-x"

elif [ "$elasticsearch_url" == "2" ]; then
   es_container_name_part="ES-5-4-3"

else [ "$elasticsearch_url" == "3" ]
   es_container_name_part="ES-6-2-x"
fi
# Docker File for Web Server

# Docker file for Mysql Server
# Docker file for Elasticsearch Server

# Docker Compose File for Multiple containers
sudo tee /opt/instance_yml/$instance_name/docker-compose.yml > /dev/null <<EOF
version: '$docker_composer_file_ver'
services:
    web-server:
        container_name: "${instance_name}-web-server-${web_container_name_part}"
        image: ${web_image_url}
        ports:
            - "${available_web_port}:80"
            - "${apache_ssh_port}:22"
        extra_hosts:
            - "yourweb-domain-web.local:127.0.0.1"
        volumes:
            - "${instance_name}-${web_container_name_part}:/var/www/html"
        deploy:
            resources:
                limits:
                    memory: 1024M
                    cpus: '0.05'
                reservations:
                    cpus: '0.025'
                    memory: 512M
        depends_on:
            - mysql
            - elasticsearch
        links:
            - mysql
            - elasticsearch
        environment:
            - "APACHE_RUN_USER=www-data"
            - "APACHE_RUN_GROUP=www-data"
    mysql:
        container_name: "${instance_name}-${mysql_container_name_part}"
        image: ${mysql_image_url}
        volumes:
            - "${instance_name}-${mysql_container_name_part}:/var/lib/mysql"
        environment:
            - MYSQL_ROOT_PASSWORD=123456
            - MYSQL_USER=root
            - MYSQL_PASSWORD=123456
    elasticsearch:
        container_name: "${instance_name}-${es_container_name_part}"
        image: ${es_image_url}
        environment:
            - cluster.name=docker-cluster
            - bootstrap.memory_lock=true
            - xpack.security.enabled=false
            - "ES_JAVA_OPTS=-Xms1g -Xmx1g"
        ulimits:
            memlock:
                soft: -1
                hard: -1
volumes:
    ${instance_name}-${web_container_name_part}:
    ${instance_name}-${mysql_container_name_part}:
    ${instance_name}-redis:
EOF
chmod +x /opt/instance_yml/$instance_name/docker-compose.yml
chmod +x /opt/instance_yml/$instance_name/Dockerfile
chmod +x /opt/instance_yml/$instance_name/mysql/Dockerfile
chmod +x /opt/instance_yml/$instance_name/elasticsearch/Dockerfile
#cp $(pwd)/Dockerfile /opt/instance_yml/$instance_name/
#mkdir /opt/instance_yml/$instance_name/mysql
#mkdir /opt/instance_yml/$instance_name/elasticsearch
#cp $(pwd)/mysql/Dockerfile /opt/instance_yml/$instance_name/mysql
#cp $(pwd)/elasticsearch/Dockerfile /opt/instance_yml/$instance_name/elasticsearch
cd /opt/instance_yml/$instance_name/
docker-compose build
docker-compose up -d
sleep 15
#Docker container services starting web, mysql, elasticsearch
docker exec ${instance_name}-web-server-${web_container_name_part} service apache2 start
docker exec ${instance_name}-${mysql_container_name_part} service mysql start
docker exec ${instance_name}-${es_container_name_part} service elasticsearch start

#Docker container ssh password resetting
docker exec ${instance_name}-web-server-${web_container_name_part} echo "root:'${web_container_root_password}'" | chpasswd
docker exec ${instance_name}-${mysql_container_name_part} echo "root:'${web_container_root_password}'" | chpasswd
docker exec ${instance_name}-${es_container_name_part} echo "root:'${web_container_root_password}'" | chpasswd
#sshPermitRoot=$(echo "PermitRootLogin yes" >> sshd_config_copy)
#docker exec -it ${instance_name}-web-server-${web_container_name_part} ${sshPermitRoot}
