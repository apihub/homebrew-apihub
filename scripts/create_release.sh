#!/bin/bash -e

# This script builds and uploads backstage's client to Github.
#
#   You need to export one environment variable called GITHUB_TOKEN.
#   You should be able to create one token at https://github.com/settings/applications
#   This script assumes that you have github-release installed (https://github.com/aktau/github-release).
#
# Usage:
#
#   % ./create-package.sh
current_path=`pwd`
destination_dir="/tmp/dist-src"

function download {
    echo -n "Downloading backstage-client source... "
    mkdir -p /tmp/backstage-client/src /tmp/backstage-client/pkg
    GOPATH=/tmp/backstage-client go get -d github.com/backstage/backstage-client/...
    pushd /tmp/backstage-client/src/github.com/backstage/backstage-client > /dev/null 2>&1
    git checkout master >/dev/null 2>&1
    echo "ok"
    echo -n "Restoring dependencies... "
    GOPATH=/tmp/backstage-client godep restore ./...
    popd > /dev/null 2>&1
    echo "ok"
}

function get_version {
    GOPATH=/tmp/backstage-client go build -o backstage github.com/backstage/backstage-client/backstage
    echo $(./backstage --version | awk '{print $3}' | sed -e 's/\.$//')
    rm backstage
}

function package {
    echo -n "Creating package... "
    pushd /tmp/backstage-client
    tar -czf $1 *
    shasum -a 256 $1
    popd
    echo "ok"
}

function update_formula {
    echo -n "Updating and tagging formula..."
    file_path=${destination_dir}/$1
    sha=$(shasum -a 256 ${file_path}|awk -F' ' '{ print $1}')
    github_link=$(echo "https://github.com/backstage/backstage-client/releases/download/$2/$1" | sed 's/\//\\\//g')
    sed -i "" "s/url '.*'/url '${github_link}'/g" ${current_path}/../Formula/backstage.rb
    sed -i "" "s/sha256 '.*'/sha256 '${sha}'/g" ${current_path}/../Formula/backstage.rb
    echo "ok"
}

echo -n "Creating \"$destination_dir\" directory... "
mkdir -p $destination_dir
echo "ok"

download
client_version=$(get_version)
package ${destination_dir}/backstage-client-${client_version}.tar.gz

cd ${destination_dir}

echo -n "Uploading file to Github... "
github-release release --security-token $GITHUB_TOKEN --user backstage --repo backstage-client --tag ${client_version} --pre-release
github-release upload --security-token $GITHUB_TOKEN --user backstage --repo backstage-client --tag ${client_version} --name backstage-client-${client_version} --file backstage-client-${client_version}.tar.gz
echo "ok"
update_formula backstage-client-${client_version}.tar.gz ${client_version}

echo -n "Removing temporary folder..."
rm -rf /tmp/backstage-client
echo "ok"

echo -n "Generating tag and commiting..."
cd ${current_path}/..
git commit -am ${client_version}
git tag ${client_version}
echo "ok"
