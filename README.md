# GitServerTool
A little tool easily create / delete / list your git repositories on your server.

## Prerequisites

* Linux (tested on Ubuntu 16.04) - Others OS might come later
* bash (tested with 4.3.48)

## How to install

### Server Side

Create a new user or use an existing one

```
#> adduser "user_name"
```

Create a 'repositories' directory in this user home directory

```
#> su "username"
#> mkdir repositories
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

### Delete a repository

### List your repositories


## TODO
* Redo Readme
* Do Client.sh helper
* Compatibility check with other OS than debian

## Authors

* **Nathan Hautbois** - [Waether](https://github.com/Waether)
