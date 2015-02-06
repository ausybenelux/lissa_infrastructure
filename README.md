# LISSA Vagrant development box

This project will set up a Vagrant environment to develop and test the LISSA
Drupal backend project. After provisioning the box you'll get a fresh Drupal 8
environment with the latest LISSA Drupal backend code at http://lissa.dev.

The LISSA backend itself is a Drupal 8 installation profile, located in its own
git repository at git@gitlab.crosscheck.be:lissa/lissa_kickstart.git. A working copy will be
installed at docroot/profiles/lissa_kickstart.

## Requirements

- SquidMan or another proxy: http://squidman.net/squidman/.
- Allow HTTP access in Squid. With SquidMan, go to prefernces -> Template -> Comment `http_access deny all`
- Virtualbox 4.3.10+
- Vagrant 1.6.3
    - Vagrant Omnibus plugin. Use `vagrant plugin install vagrant-omnibus`, if
      the installer returns an error about not being able to install 'nokogiri'
      then install the xcode command line tools by executing `xcode-select --install`
    - Vagrant Hostsupdater plugin. Use `vagrant plugin install vagrant-hostsupdater`
    - Vagrant ProxyConf plugin. Use `vagrant plugin install vagrant-proxyconf`
- Access to the git@gitlab.crosscheck.be:lissa/lissa_kickstart.git repository
- A running SSH agent with they key that has access to the lissa_kickstart
  repository. Use `ssh-add /path/to/private_key` to add your key.

## Installation

- cd to the root of this project
- Execute `vagrant up --provision` (takes at least 10 minutes)
- On the host machine, go to http://admin.lissa.dev
- Login with admin:admin

## Usage

- Drupal backend URL: http://admin.lissa.dev
- Host path to drupal: admin-server/docroot
- Vagrant path to drupal: /var/www/admin-server/docroot
- Development should happen in admin-server/profiles/lissa_kickstart, which is a
  clone of the 8.x-1.x branch of the lissa_kickstart repository.

## Demo

- Clean up the current Drupal installation.
  - Empty the sites/default/files directory.
  - Copy paste the contents of the sites/default/default.settings.php file to
    the sites/default/settings.php.
  - Drop the database.
- Execute the installation instructions in this file.
- Add two event nodes witht the following endpoints:
  - https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8
  - https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8
- Run the iOS project.
