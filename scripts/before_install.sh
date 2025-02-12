#!/bin/bash
set -e  # Exit if any command fails

# Execute commands directly inside the script
echo "Running BeforeInstall commands..."

sudo yum update -y
sudo yum install -y nodejs

# Alternative inline execution using a one-liner
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install 18
nvm use 18
node -v
npm -v
sudo mkdir -p /home/ec2-user/pizza-luvrs
sudo chown -R ec2-user:ec2-user /home/ec2-user/pizza-luvrs  
cd /home/ec2-user/pizza-luvrs
git clone https://github.com/juanmiguelnz/pizza-luvrs.git

