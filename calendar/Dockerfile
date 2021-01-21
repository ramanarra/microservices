#pulling node image from dockerhub
From node:10.23.1     

# create and set app directory
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/calendar
WORKDIR /usr/src/app/calendar

#install required dependencies from package.
COPY package.json /usr/src/app/calendar
COPY nest-cli.json /usr/src/app/calendar
COPY tsconfig.build.json /usr/src/app/calendar
COPY tsconfig.json /usr/src/app/calendar

#install and run common dto
RUN mkdir -p /usr/src/app/common-dto
WORKDIR /usr/src/app/common-dto

#copying common-dto project file to dest. folder
COPY common-dto/. /usr/src/app/common-dto

RUN npm install
RUN npm install -g @nestjs/cli
RUN npm run build



WORKDIR /usr/src/app/calendar
RUN npm install
RUN npm run build

#copying project file to dest. folder
COPY . /usr/src/app/calendar


#RUN $env:NODE_ENV=default

#CMD ["npm", "run", "start"]







