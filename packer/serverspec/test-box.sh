#!/usr/bin/env bash

create_vagrantfile_linux() {
vagrant plugin list | (grep vagrant-serverspec > /dev/null) || vagrant plugin install vagrant-serverspec
cat << EOF > $tmp_path/Vagrantfile
Vagrant.configure('2') do |config|
  config.vm.box = '$box_name'

  config.vm.provision :serverspec do |spec|
    spec.pattern = '$test_src_path'
  end
end
EOF
}

box_path="../centos6-x64.box"
test_src_path="$(pwd)/test/*_spec.rb"

box_filename=$(basename "${box_path}")
box_name=${box_filename%.*}
tmp_path=/tmp/boxtest

rm -rf ${tmp_path}

export VAGRANT_CWD="/"
vagrant box remove ${box_name}
vagrant box add ${box_name} ${box_path}

mkdir -p ${tmp_path}

pushd ${tmp_path}
create_vagrantfile_linux

export VAGRANT_CWD="$(pwd)"
vagrant up
if (($? > 0)); then
  echo "There was an error!"
fi
sleep 10
vagrant destroy -f
popd

export VAGRANT_CWD="/"
vagrant box remove ${box_name}
unset VAGRANT_CWD
rm -rf ${tmp_path}
