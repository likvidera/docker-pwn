#! /usr/bin/env bash

function check_root() {
  if [[ $EUID -ne 0 ]]; then
   echo "[-] The installation must be run as root" 1>&2
   exit 0
  fi
}

function check_if_installed() {
  if type "$1" > /dev/null 2>&1; then
    echo "[*] $1 is already installed ... skipping!"
    return 1
  else
    return 0
  fi
}

function install_deps() {
  echo "[+] Updating and upgrading ..."
  apt-get -y update --fix-missing
  apt-get -y upgrade

  echo "[+] Generating locale ..."
  locale-gen en_US.UTF-8
}

function install_docker() {
  check_if_installed "docker"
  if [[ $? == 1 ]] ; then
    return
  fi

  install_deps
  echo "[+] Installing docker ..."
  apt-get -y remove docker docker-engine
  apt-get -y install \
      linux-image-extra-$(uname -r) \
      linux-image-extra-virtual
  apt-get -y install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
   add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable"
  apt-get -y update --fix-missing
  apt-get -y install docker-ce

  usermod -aG docker ${SUDO_USER}
}

function install_docker_compose() {
  check_if_installed "docker-compose"
  if [[ $? == 1 ]] ; then
    return
  fi

  echo "[+] Installing docker-compose"
  curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose
}

check_root
install_docker
install_docker_compose
