# GitServerTool
A little tool to easily create / delete / list your git repositories on your server.

## Prerequisites

* Linux (tested on Ubuntu 16.04) - Others OS might come later
* bash (tested with 4.3.48)
* git (tested with 2.7.4)

## How to install

### Server Side

Create a new user or use an existing one

I personaly used git as username

```
#> adduser username
```

Create a 'repositories' directory in this user home directory

```
#> su username
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

```
#> ./Client.sh -Cr repository-name
```

### Clone a repository

```
#> ./Client.sh -Cl repository-name
```

### Delete a repository

```
#> ./Client.sh -D repository-name
```

### List your repositories

```
#> ./Client.sh -L
```

## TODO
* Compatibility check with other OS than debian
* Support multiple server
* Modify so it doesn't need bash
* Clean all scripts

## Authors

* **Nathan Hautbois** - [Waether](https://github.com/Waether)
