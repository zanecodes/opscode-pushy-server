Overview
========

"pushy" is the internal nickname for the new push job feature. In this repo you
will find:

* A org-mode file describing the overall design
* A spec compliant agent suitable for production deployment
* A spec compliant server suitable for inclusion in a production OPC installation.

Run ALL THE THINGS
==================

## Ensure host-based checkouts of all projects are on the correct branches

* `opscode-omnibus` => pushy
* `mixlib-authorization` => pushy
* `pushy` => 54/integration

## Reconfigure OPC

Load `opscode-omnibus` and generate the artisanal OPC-specific app.config for pushy:

    $ cd ~/oc/opscode-dev-vm
    $ rake project:load[opscode-omnibus]
    $ rake update

## Load required projects into dev-vm

    $ cd ~/oc/opscode-dev-vm
    $ rake project:load[mixlib-authorization]
    $ rake project:load[pushy]

## Load the schema

SSH into the dev-vm and run Sequel migrations:

    $ cd ~/oc/opscode-dev-vm
    $ rake ssh
    vagrant@private-chef:~$ cd /srv/piab/mounts/mixlib-authorization
    vagrant@private-chef:/srv/piab/mounts/mixlib-authorization$ bundle exec sequel -m db/migrate postgres://opscode-pgsql@127.0.0.1/opscode_chef

## Start the pushy server

    $ cd ~/oc/opscode-dev-vm
    $ rake ssh
    vagrant@private-chef:~$ cd /srv/piab/mounts/pushy
    vagrant@private-chef:/srv/piab/mounts/pushy$ ./rel/pushy/bin/pushy console

## Start a client

Start a client on your host:

    $ cd ~/oc/pushy/client
    $ bundle install
    $ ./bin/pushy-client -v -n DERPY

Feel free to start multiple clients..just be sure to give them all a
different name.
