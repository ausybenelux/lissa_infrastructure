# LISSA Vagrant development box

This project will set up a Vagrant environment to develop and test the LISSA
Drupal backend project. After provisioning the box you'll get a fresh Drupal 8
environment with the latest LISSA Drupal backend code at http://lissa.dev.

The LISSA backend itself is a Drupal 8 installation profile, located in its own
git repository at git@gitlab.crosscheck.be:lissa/lissa_kickstart.git. A working copy will be
installed at docroot/profiles/lissa_kickstart.

## Requirements

- Virtualbox 4.3.10+
- Vagrant 1.6.3+
    - Vagrant Omnibus plugin. Use `vagrant plugin install vagrant-omnibus`, if
      the installer returns an error about not being able to install 'nokogiri'
      then install the xcode command line tools by executing `xcode-select --install`
    - Vagrant Hostsupdater plugin. Use `vagrant plugin install vagrant-hostsupdater`
    - Vagrant ProxyConf plugin. Use `vagrant plugin install vagrant-proxyconf`

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
  clone of the 8.0.x branch of the lissa_kickstart repository.
