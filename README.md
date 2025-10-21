# Customised PHP container

Based on Red Hat's UBI10 packages, additional packages are added to provide a more complete container for deployment of Drupal apps.

Currently based on the php83 UBI container that is based on PHP 8.3.

## Current modifications from upstream UBI package:

Create dockerfile to customise UBI10 image to:
- disable all enabled repositories
- enable ubi10 repositories
- install EPEL repository from rpm
- Install Centos Stream repositories from rpm
- dnf update epel* and centos* to make sure latest version of repository files are installed.
- ~~Enable usr/bin/crb~~
- install the following packages:
    - jq
    - composer
    - ImageMagick-libs
    - ImageMagick
    - mariadb-client-utils
