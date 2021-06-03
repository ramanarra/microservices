# README #

### Pre-requisites
* Docker - [Installation](https://docs.docker.com/docker-for-windows/install/) .  
* Wsl 2 - [Download page](https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-4---download-the-linux-kernel-update-package).

### Installation Steps

## Backend 
```
1)git clone https://virujh@bitbucket.org/virujh/nest-microservice.git
2)git checkout -b dockerSetup origin/dockerSetup
3)SSH setup in cmd:
  ssh-keygen
  navigate to C:\Users\your_username\.ssh.
  Copy id_rsa and replace it with id_rsa in project folder
4)Navigate to backend-project folder in command prompt and give docker run commands:
  local       - docker-compose -f docker-compose.yml up
  Development - docker-compose -f docker-compose-dev.yml up
  Production  - docker-compose -f docker-compose-prod.yml up
```
To stop the containers
```
  local       - docker-compose -f docker-compose.yml up
  Development - docker-compose -f docker-compose-dev.yml up
  Production  - docker-compose -f docker-compose-prod.yml up

```
Useful Docker Commands
```
kill all running containers with docker kill $(docker ps -q)
delete all stopped containers with docker rm $(docker ps -a -q)
delete all images with docker rmi $(docker images -q)
```


