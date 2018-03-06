# GitServerTool
A little tool to easily create / delete / list your git repositories on your server.

## Prerequisites

* Linux (tested on Ubuntu 16.04) - Should be compatible with others Linux based OS
* git (tested with 2.7.4)
* ssh

## How to install

### Server Side

Create a new user or use an existing one

I personaly used 'git' as username

```
#> adduser username
```

Create a 'repositories' directory in this user home directory

```
#> su username
#> ./Server.sh --install
or
#> cd ~
#> mkdir ~/repositories
```

### Client side

For convenience considere using an alias to call Client.sh

Run Client.sh configuration option

It will ask you your server IP and the name of the user you created previously

```
#> ./Client.sh --configure
```

You are now done.

## How To

### Create a repository

This will initialize a bare git repository on your server 

```
#> ./Client.sh -Cr repository_name
```

### Clone a repository

This will clone your repository in your current directory

You could also use 'git clone username@server-ip:~/repositories/repository_name'

```
#> ./Client.sh -Cl repository_name
```

### Delete a repository

This will delete your repository on your server

/!\ Warning /!\ There will be no way of recovering your repository content unless you have cloned it before 

```
#> ./Client.sh -D repository_name
```

### List your repositories

Display all git repositories on your server 

```
#> ./Client.sh -L
```

## TODO
* Support multiple server

## Authors

* **Nathan Hautbois** - [Waether](https://github.com/Waether)
