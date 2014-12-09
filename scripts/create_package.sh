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
}

echo -n "Creating \"$destination_dir\" directory... "
mkdir -p $destination_dir
echo "ok"

download
client_version=$(get_version)
package ${destination_dir}/backstage-client-${client_version}.tar.gz

rm -rf /tmp/backstage-client
cd ${destination_dir}

echo -n "Uploading file to Github... "
github-release release --security-token $GITHUB_TOKEN --user backstage --repo backstage-client --tag ${client_version} --pre-release
github-release upload --security-token $GITHUB_TOKEN --user backstage --repo backstage-client --tag ${client_version} --name backstage-client-${client_version} --file backstage-client-${client_version}.tar.gz