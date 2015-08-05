#!/bin/bash -e

# This script builds and uploads apihub's cli to Github.
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
    echo -n "Downloading apihub-cli source... "
    mkdir -p /tmp/apihub-cli/src /tmp/apihub-cli/pkg
    GOPATH=/tmp/apihub-cli go get -d github.com/apihub/apihub-cli/...
    pushd /tmp/apihub-cli/src/github.com/apihub/apihub-cli > /dev/null 2>&1
    git checkout master >/dev/null 2>&1
    echo "ok"
    echo -n "Restoring dependencies... "
    GOPATH=/tmp/apihub-cli godep restore ./...
    popd > /dev/null 2>&1
    echo "ok"
}

function get_version {
    GOPATH=/tmp/apihub-cli go build -o apihub github.com/apihub/apihub-cli/apihub
    echo $(./apihub --version | awk '{print $3}' | sed -e 's/\.$//')
    rm apihub
}

function package {
    echo -n "Creating package... "
    pushd /tmp/apihub-cli
    tar -czf $1 *
    shasum -a 256 $1
    popd
    echo "ok"
}

function update_formula {
    echo -n "Updating and tagging formula..."
    file_path=${destination_dir}/$1
    sha=$(shasum -a 256 ${file_path}|awk -F' ' '{ print $1}')
    github_link=$(echo "https://github.com/apihub/apihub-cli/releases/download/$2/$1" | sed 's/\//\\\//g'| awk -F ".tar.gz" '{print $1}')
    sed -i "" "s/url '.*'/url '${github_link}'/g" ${current_path}/../Formula/apihub.rb
    sed -i "" "s/sha256 '.*'/sha256 '${sha}'/g" ${current_path}/../Formula/apihub.rb
    echo "ok"
}

echo -n "Creating \"$destination_dir\" directory... "
mkdir -p $destination_dir
echo "ok"

download
cli_version=$(get_version)
package ${destination_dir}/apihub-cli-${cli_version}.tar.gz

cd ${destination_dir}

echo -n "Uploading file to Github... "
github-release release --security-token $GITHUB_TOKEN --user apihub --repo apihub-cli --tag ${cli_version} --pre-release
github-release upload --security-token $GITHUB_TOKEN --user apihub --repo apihub-cli --tag ${cli_version} --name apihub-cli-${cli_version} --file apihub-cli-${cli_version}.tar.gz
echo "ok"
update_formula apihub-cli-${cli_version}.tar.gz ${cli_version}

echo -n "Removing temporary folder..."
rm -rf /tmp/apihub-cli
echo "ok"

echo -n "Generating tag and commiting..."
cd ${current_path}/..
git commit -am ${cli_version}
git tag ${cli_version}
echo "ok"
