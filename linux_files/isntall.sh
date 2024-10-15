#!/bin/bash -x
sudo apt install -y eza bat zip \
golang-go python3 python3-pip \
gcc g++ make \
libsqlite3-dev libssl-dev \
wget jq

echo -e '#!/bin/bash\napt update && apt upgrade -y' | sudo tee /etc/cron.daily/apt-upgrade && sudo chmod +x /etc/cron.daily/apt-upgrade
source ~/.bashrc