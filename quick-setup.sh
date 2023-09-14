#!/bin/bash
# For internal use only. No support provided.
set -e;

if ! command -v git &> /dev/null
then
  # Prepare Dir
  echo "-> WARN: Git not installed, using curl <-" 1>&2;
  cd ~;rm -rf l2;mkdir l2;cd l2;
  curl -fsSL -o .zip https://github.com/NexusFrontend/socket-echo/archive/refs/heads/master.zip;unzip .zip;rm .zip;mv socket-echo-master svc;cd svc;
else
  # Clone Repo
  cd ~;mkdir -p l2;cd l2;
  git clone https://github.com/NexusFrontend/socket-echo.git svc;cd svc;
fi

if ! command -v rustc &> /dev/null
then
 echo "Rust not found, installing...";
 curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh;
 source $HOME/.cargo/env;
fi

echo "Compiling"
make;

if [ -f ~/latency/start.sh ]; then
  echo '#!/bin/bash' > ~/latency/start.sh;
  echo "cd \"$(pwd)\";" >> ~/latency/start.sh;
  echo "make run;" >> ~/latency/start.sh;
  chmod +x ~/latency/start.sh;
fi;

echo "Done!"
