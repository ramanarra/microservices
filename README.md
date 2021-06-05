# README #

### Pre-requisites
Windows
* Docker - [Installation](https://docs.docker.com/docker-for-windows/install/) .  
* Wsl 2 - [Download page](https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package).

Unix OS
* Docker and docker-compose is to be installed mandatoryly. 

### Installation Steps

## Backend 
```
1)sudo su
2)git clone https://virujh@bitbucket.org/virujh/nest-microservice.git
3)git checkout <latest-branch>
4)Navigate to project root folder and enter following commands based on environment to run project.
  Local       - docker-compose -f docker-compose.yml -f docker-compose-loc up -d
  Development - docker-compose -f docker-compose.yml -f docker-compose-dev up -d
  Production  - docker-compose -f docker-compose.yml -f docker-compose-prod up -d
```

Commands to stop and remove container:
  Local       - docker-compose -f docker-compose.yml -f docker-compose-loc down
  Development - docker-compose -f docker-compose.yml -f docker-compose-dev down
  Production  - docker-compose -f docker-compose.yml -f docker-compose-prod down

Commands to view and remove images:

To list images   - docker images
To remove images - docker rmi <image-name>
