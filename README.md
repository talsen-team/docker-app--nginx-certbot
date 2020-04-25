# Question: Running Theia web on non-root url path.

For pre-requisites take a look at [how to use](#how-to-use).

Clone this repository anywhere via:  
```git clone --recurse-submodules --branch=question-theia-non-root-url https://github.com/talsen-team/docker-app--nginx-certbot.git```  
Open the repository with VS Code:  
```code docker-app--nginx-certbot```  
Run the command ```docker-compose--compose--up``` via VS Code and wait for the ```volumes/proxy/cache/dhparams.pem``` file being generated (instead also the terminal command ```sudo bash bash-commands/docker-compose--compose--up.sh . default.docker-compose```).  
Run the command ```administration--update-configuration``` via VS Code (instead also the terminal command ```sudo bash bash-commands--specific/administration--update-configuration.sh . default.docker-compose reverse-proxy.env```).  
Open the web browser ```xdg-open http://localhost```, you should see a certificate warning (due to self signed certificate), click on proceed and you should see theia being served under ```https://localhost/non-root/#/home/project```.

The used docker-compose configuration can be found [here](docker-compose/server--nginx-certbot/default.docker-compose).  
Theia and NGINX are connected via the labeled docker network ```local```, so theia is inaccessible on the system without NGINX.
The used reverse proxy configuration can be found [here](volumes/proxy/manual-config/localhost.conf).  
In line 27 you can see ```proxy_pass              http://ide:3000/;```, to get theia being proxied correctly, the trailing slash ```...ide:3000/;``` does the trick, this way the ```/non-root/``` URL part seems to be replaced by ```/```.

Disclaimer: This is only an example, I strongly discourage you from using it in a production scenario. Consider using your own NGINX proxy and theia IDE docker images.

# docker-app: nginx-certbot

![GitHub tag (latest by date)](https://img.shields.io/github/tag-date/talsen-team/docker-app--nginx-certbot.svg?style=for-the-badge)
[![Docker Automated build](https://img.shields.io/docker/cloud/automated/talsenteam/docker-nginx-certbot.svg?style=for-the-badge)](//hub.docker.com/r/talsenteam/docker-nginx-certbot/)
[![Docker Pulls](https://img.shields.io/docker/pulls/talsenteam/docker-nginx-certbot.svg?style=for-the-badge)](//hub.docker.com/r/talsenteam/docker-nginx-certbot/)
[![Docker Build Status](https://img.shields.io/docker/cloud/build/talsenteam/docker-nginx-certbot.svg?style=for-the-badge)](//hub.docker.com/r/talsenteam/docker-nginx-certbot/)

The server application nginx-certbot ready to run inside a docker container.

## how to use

To easily experiment with nginx-certbot, the following pre-requisites are preferred:

1. Install [VS Code](//code.visualstudio.com/), to easily use predefined [tasks](.vscode/tasks.json)
2. Install any [ssh-askpass](//man.openbsd.org/ssh-askpass.1) to handle sudo prompts required for docker  
   (VS Code does not run as root user, so in order to perform sudo operations the [`sudo --askpass CMD`](//github.com/talsen-team/docker-util--bash-util/blob/master/elevate.sh) feature is used)
3. Install docker (at least version 18.09.1, build 4c52b90)
4. Install docker-compose (at least version 1.21.2, build a133471)

Then open the cloned repository directory with VS Code and use any of the custom tasks.

## custom VS Code tasks

Any docker-compose--* tasks refer to the default [dockerfile](docker/server--nginx-certbot/default.docker) as well as to the [docker-compose](docker-compose/server--nginx-certbot/default.docker-compose) configuration if required for command execution.

- administration--*
  - [administration--update-configuration](bash-commands--specific/administration--update-configuration.sh)  
    Updates the NGINX configuration by generating necessary config files and requesting required certificates via certbot.
- browser--*
  - [browser--open-application-url](//github.com/talsen-team/docker-util--bash-commands/blob/master/browser--open-application-url.sh)  
    Opens the localhost docker service URL in the default web-browser. The opened URL is defined in [host.env](host.env) by the variable HOST_SERVICE_URL.
- docker-compose--*
  - docker-compose--compose--*
    - [docker-compose--compose--create](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--compose--create.sh)  
      Creates required docker containers and docker networks but does not start them.
    - [docker-compose--compose--down](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--compose--down.sh)  
      Stops and removes required docker containers and docker networks.
    - [docker-compose--compose--up](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--compose--up.sh)  
      Creates and starts required docker containers and docker networks.
  - docker-compose--container--*
    - [docker-compose--container--kill](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--container--kill.sh)  
      Kills all running containers declared by the compose configuration.
    - [docker-compose--container--restart](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--container--restart.sh)  
      Restarts all containers declared by the compose configuration (if they were created before).
    - [docker-compose--container--start](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--container--start.sh)  
      Starts all containers declared by the compose configuration (if they were created before).
    - [docker-compose--container--stop](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--container--stop.sh)  
      Stops all running containers declared by the compose configuration.
  - docker-compose--image--*
    - [docker-compose--image--build](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--image--build.sh)  
      Builds all required docker images referenced by the compose configuration (using build cache).
    - [docker-compose--image--pull](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--image--pull.sh)  
      Pulls all required docker images referenced by the compose configuration from the [docker hub](//hub.docker.com).
    - [docker-compose--image--rebuild](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--image--rebuild.sh)  
      Builds all required docker images referenced by the compose configuration (without using build cache).
  - docker-compose--log--*
    - [docker-compose--log--container-info](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--log--container-info.sh)  
      Prints general conntainer informations regarding the compose configuration to the console.
    - [docker-compose--log--container-log](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--log--container-log.sh)  
      Prints logs of running containers declared by the compose configuration to the console.
  - docker-compose--system--*
    - [docker-compose--system--clean](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--system--clean.sh)  
      Removes local dangling docker containers, images and networks.
    - [docker-compose--system--prune](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--system--prune.sh)  
      Prunes the local docker system.
  - docker-compose--volumes--*
    - [docker-compose--volumes--wipe-local](//github.com/talsen-team/docker-util--bash-commands/blob/master/docker-compose--volumes--wipe-local.sh)  
      Wipes local volume mapping directories, located in the subdirectory 'volumes/', if there are any.
- git--*
  - [git--pull-and-update-submodules](//github.com/talsen-team/docker-util--bash-commands/blob/master/git--pull-and-update-submodules.sh)  
    Rebase pulls the latest repository changes and the updates all git submodules if there are any.

## custom scripts for interaction via terminal / in non-interactive mode

Call the scripts from the repository root directory ( e.g. `bash bash-ci/command-deploy.sh` ).  

- [command-deploy](bash-ci/command-deploy.sh):  
  1. Runs VS Code task `docker-compose--compose--up`
  2. Runs VS Code task `administration--update-configuration`

- [command-pull-images](bash-ci/command-pull-images.sh):  
  1. Runs VS Code task `docker-compose--image--pull`.  

- [command-purge](bash-ci/command-purge.sh):  
  1. Runs VS Code task `docker-compose--compose--down`.  

- [command-upgrade](bash-ci/command-upgrade.sh):  
  1. Runs VS Code task `docker-compose--compose--down`
  2. Deletes the old backup directory `delete.volumes/` if existent
  3. Degrades backup directory `volumes.bak/` to old backup directory `delete.volumes/`
  4. Creates a backup of the `volumes/` directory named `volumes.bak/`
  5. Checks out the latest state of this repository
  6. Runs VS Code task `docker-compose--image--pull`
  7. Runs VS Code task `docker-compose--compose--up`
  8. Runs VS Code task `administration--update-configuration`
