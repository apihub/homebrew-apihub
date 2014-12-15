#backstage-client

This repository is based on the one created by [Tsuru team](https://github.com/tsuru/homebrew-tsuru).

##Usage

First, add this tap:

	% brew tap backstage/homebrew-backstage

Then install the desired formula:

	% brew install backstage

If you want to uninstall the backstage command line from your computer:

	% brew uninstall backstage

##Publish a new version

> You need to export one environment variable called GITHUB_TOKEN.
> (You should be able to create one token at https://github.com/settings/applications)

> This script assumes that you have github-release installed (https://github.com/aktau/github-release).

	% chmod +x scripts/create_release.sh
	% ./create_release.sh

The output looks like the following:

	Creating "/tmp/dist-src" directory... ok
	Downloading backstage-client source... ok
	Restoring dependencies... ok
	Creating package...ok
	Uploading file to Github...ok
	Updating and tagging formula...ok
	Removing temporary folder...ok
	Generating tag and commiting...ok
