#!/bin/bash
# For internal use only. No support provided.
set -e;

source ~/.bashrc;

if ! command -v git &> /dev/null
then
  # Prepare Dir
  echo "-> WARN: Git not installed, using curl <-" 1>&2;
  cd ~;rm -rf l2;mkdir l2;cd l2;
  curl -fsSL -o .zip https://github.com/NexusFrontend/socket-echo/archive/refs/heads/master.zip;unzip .zip;rm .zip;mv socket-echo-master svc;cd svc;
else
  # Clone Repo
  cd ~;mkdir -p l2;cd l2;
  if [ -d svc ]; then
    echo "-> INFO: Directory exists, updating <-" 1>&2;
    cd svc;git pull --no-rebase;
  else
    echo "-> INFO: Directory does not exist, cloning <-" 1>&2;
    git clone https://github.com/NexusFrontend/socket-echo.git svc;cd svc;
  fi;
fi

if [ ! -f ~/.cargo/env ];
then
  echo "Rust not found, installing...";
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh;
fi
source $HOME/.cargo/env;

echo "Compiling"
make;

if [ -f ~/latency/start.sh ]; then
  echo '#!/bin/bash' > ~/latency/start.sh;
  echo "source \"\$HOME/.cargo/env\";" >> ~/latency/start.sh;
  echo "cd \"$(pwd)\";" >> ~/latency/start.sh;
  echo "make run;" >> ~/latency/start.sh;
  chmod +x ~/latency/start.sh;
fi;

echo "Creating User Systemd Service"

mkdir -p ~/.config/systemd/user;
echo "[Unit]" > ~/.config/systemd/user/latency.service;
echo "Description=Echo Service" >> ~/.config/systemd/user/latency.service;
echo "After=network.target" >> ~/.config/systemd/user/latency.service;
echo "" >> ~/.config/systemd/user/latency.service;
echo "[Service]" >> ~/.config/systemd/user/latency.service;
echo "Type=simple" >> ~/.config/systemd/user/latency.service;
echo "Restart=always" >> ~/.config/systemd/user/latency.service;
echo "ExecStart=$HOME/latency/start.sh" >> ~/.config/systemd/user/latency.service;
echo "" >> ~/.config/systemd/user/latency.service;
echo "[Install]" >> ~/.config/systemd/user/latency.service;
echo "WantedBy=default.target" >> ~/.config/systemd/user/latency.service;

echo "Done!"
