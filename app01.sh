set -e 

echo "=======updating system========"
sudo ynm update -y

echo "=========== install bash ==============="  
if ! command -v bash &> /dev/null
then 
	echo "bash not found install it "
	sudo yum install bash -y
else
	echo "bash already installed"
fi


echo "=========== install needed pkg for tomcat & install it ==============="
sudo yum install -y epel-release
sudo yum install -y java-11-openjdk java-11-openjdk-devel wget curl tar git firewalld -y
sudo cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
sudo tar xzvf apache-tomcat-9.0.75.tar.gz



echo "=========== create user for tomcat & copy data to tomcat home ==============="
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
sudo cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
sudo chown -R tomcat.tomcat /usr/local/tomcat




echo "=========== create tomcat service file ==============="
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF && echo "✅ Tomcat service file ready"
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
EOF




echo "=========== demon reload ==============="
 
sudo systemctl daemon-reload




echo "=========== enable and start  ==============="

sudo systemctl enable --now tomcat




echo "=========== enable firewall ==============="
sudo bash /vagrant/en_firwall_tomcat.sh 


echo "==== Provisioning tomcat DONE ✅😎👌 ===="
