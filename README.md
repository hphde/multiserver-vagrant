# Multiserver Vagrant

Deploy n servers with one shot

## Howto

Checkout repo, cd to it and run `vagrant up`.

Create `.env` file for alternatives and options:

```ruby
SERVERS = 3
BOX = 'centos/8'
#MEM = 1024
#CPUS = 2
#BOOTSTRAP = 'bootstrap.sh'
#NETWORK_MASK = 24
#NETWORK_BASE = '192.168.56.0'
#TIMEZONE = 'Europe/Berlin'
#PORT = 80
```

The VM port 80 is reachable over the URLs that Vagrant spits out in the end - you can adjust to other ports using the `.env` file.

## Using `bootstrap.sh` without Vagrant

You could run `bootstrap.sh` standalone on CentOS 7 or 8 and it will install EPEL, update the stack and install a few tools. The script accepts one parameter. It's the timezone - default `Europe/Berlin`.
