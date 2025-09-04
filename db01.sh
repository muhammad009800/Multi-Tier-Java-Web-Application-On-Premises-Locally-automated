sudo yum update -y
if ! command -v bash &> /dev/null
then
    echo "bash not found, installing..."
    sudo yum install -y bash
else
    echo "bash already installed"
fi
sudo yum install epel-release -y
Sudo yum install git mariadb-server -y
sudo systemctl enable --now mariadb
sudo bash /vagrant/secure_mysql.sh
sudo mysql -u root -padmin123 < /vagrant/init-tomcatdb.sql
sudo git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
sudo mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql
sudo mysql -u root -padmin123 accounts <<EOF
SHOW TABLES;
EOF
sudo systemctl enable --now mariadb
sudo bash /vagrant/en_firwall_db.sh
