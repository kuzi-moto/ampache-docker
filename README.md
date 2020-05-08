# ampache-docker

Docker container for Ampache, a web based audio/video streaming application and file manager allowing you to access your music & videos from anywhere, using almost any internet enabled device.

**build status**

![travis status](https://travis-ci.org/ampache/ampache-docker.svg?branch=master)

**Develop build status**

![travis status](https://travis-ci.org/ampache/ampache-docker.svg?branch=develop)

## Usage

To run official builds from docker hub you can run these commands:

To run the current Ampache master (stable) branch

```bash
docker run --name=ampache -d -v /path/to/your/music:/media:ro -p 80:80 ampache/ampache
```

To run the current Ampache develop branch

```bash
docker run --name=ampache -d -v /path/to/your/music:/media:ro -p 80:80 ampache/ampache:develop
```

The develop tag is set up to use git updates so you don't have to rebuild your images to stay up to date with development.

### With docker-compose

Included in the repository is a simple docker-compose.yml file to get started. To use simply do:

```bash
docker-compose up -d
```

The first time you run the container, you will also need to set the correct permissions on the configuration folder:

```bash
chown www-data:www-data conf -R
```

This will automatically create mount points for music at `./data/music`, persistent MySQL storage at `./data/mysql`, and a folder for the Ampache configuration file at `/conf`.

## Running on ARM

The automated builds for the official repo are now built for linux/amd64, linux/arm/v7 and linux/arm64.

## Installation

* MySQL Administrative Username: root    # leave alone
* MySQL Administrative Password: (blank) # leave alone
* Check "Create Database User"
* Ampache Database Username: ampache
* Ampache Database User Password: ampache # or whatever you want, but remember it on the next page
* next page fill out MySQL Username / Password
* Click the "Write" buttons from BOTTOM to TOP
* Do this because it is the last one that needs the username and password and they get blanked out on every click

## Thanks to

* @ericfrederich for his original work
* @velocity303 and @goldy for the other ampache-docker inspiration

## Current Release

4.1.1
