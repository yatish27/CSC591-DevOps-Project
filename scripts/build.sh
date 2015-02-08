#!/bin/bash -x

# This script is build script for gitlab. Everytime a build is called this will be executed
export PATH=~/bin:/usr/local/bin:/usr/bin:/bin:/var/lib/jenkins/.rvm/bin
export RAILS_ENV=test

source $HOME/.rvm/scripts/rvm

rvm use 2.1.5

# Config files should never be in version control ther are stored in home folder on the CI 
# The will be used every time a build is called 

cp $HOME/gitlab_config/database.yml config/database.yml

cp config/gitlab.yml.example config/gitlab.yml
cp config/unicorn.rb.example config/unicorn.rb
cp config/resque.yml.example config/resque.yml
cp config/initializers/rack_attack.rb.example config/initializers/rack_attack.rb

# gitlab require repos. Creating tmp folder. It will set everytime for every build
rm -f $HOME/gitlab-satellites
mkdir $HOME//gitlab-satellites
chmod u+rwx,g=rx,o-rwx $HOME//gitlab-satellites

touch log/application.log
touch log/test.log

gem install bundler --no-ri --no-rdoc
# Installing all the dependencies (It is like make in C)
bundle install --without postgres production
