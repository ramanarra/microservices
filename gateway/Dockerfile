#pulling node image from dockerhub
FROM node:10.23.1    

# Update aptitude with new repo
#RUN apt-get update

# Install software 
RUN apt-get install -y git
# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
# Warning! Anyone who gets their hands on this image will be able
# to retrieve this private key file from the corresponding image layer

ADD id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN chown -R root:root /root/.ssh


# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add bitbuckets key
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts 

# create and set app directory
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/gateway
WORKDIR /usr/src/app/gateway

#install required dependencies from package.
COPY package.json /usr/src/app/gateway
COPY nest-cli.json /usr/src/app/gateway
COPY tsconfig.build.json /usr/src/app/gateway
COPY tsconfig.json /usr/src/app/gateway

#install and run common dto



#RUN mkdir -p /usr/src/app/common-dto
WORKDIR /usr/src/app

#copying common-dto project file to dest. folder
#COPY common-dto/. /usr/src/app/common-dto

# Clone the conf files into the docker container
RUN git clone git@bitbucket.org:virujh/common-dto.git

WORKDIR /usr/src/app/common-dto



RUN npm install
RUN npm install -g @nestjs/cli
RUN npm run build



WORKDIR /usr/src/app/gateway
RUN npm install
RUN npm run build

#copying project file to dest. folder
COPY . /usr/src/app/gateway

#RUN $env:NODE_ENV=default

#CMD ["npm", "run", "start"]

