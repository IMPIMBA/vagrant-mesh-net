#!/usr/bin/env bash

create_vagrantfile() {
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

base_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
box_path="$base_path/../centos6-x64.box"
test_src_path="$base_path/test/*_spec.rb"

box_filename=$(basename "${box_path}")
box_name=${box_filename%.*}
tmp_path=/tmp/boxtest

rm -rf ${tmp_path}

export VAGRANT_CWD="/"
vagrant box remove ${box_name} &> /dev/null
vagrant box add ${box_name} ${box_path} &> /dev/null

mkdir -p ${tmp_path}

pushd ${tmp_path} &> /dev/null
create_vagrantfile

export VAGRANT_CWD="$(pwd)"
vagrant up
if (($? > 0)); then
  errorcode=1
else
  errorcode=0
fi
sleep 10
vagrant destroy -f &> /dev/null
popd &> /dev/null

export VAGRANT_CWD="/"
vagrant box remove ${box_name} &> /dev/null
unset VAGRANT_CWD
rm -rf ${tmp_path}

exit $errorcode
