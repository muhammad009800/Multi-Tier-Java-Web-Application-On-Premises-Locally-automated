set -e
sudo apt update
sudo apt upgrade
sudo apt install git maven -y
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mvn install


echo "======= Copy WAR to Tomcat VM ======="
scp /home/vagrant/myapp/target/*.war vagrant@tomcat.local:/home/vagrant/
ssh vagrant@tomcat.local "sudo mv /home/vagrant/*.war /usr/local/tomcat/webapps/"

echo "======= Trigger Tomcat deployment ======="
ssh -o StrictHostKeyChecking=no vagrant@tomcat.local "bash /vagrant/deploy_tomcat.sh"

echo "WAR copied and Tomcat deploy triggered ✅"