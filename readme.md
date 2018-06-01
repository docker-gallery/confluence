# Supported tags and respective ```Dockerfile``` links

[![Dockerfile 6.9.0](https://img.shields.io/badge/Dockerfile-v6.9.0-blue.svg?style=flat)](https://github.com/docker-gallery/confluence/blob/v6.9.0/Dockerfile) [![Docker Hub](https://img.shields.io/badge/DockerHub-v6.9.0-blue.svg?style=flat)](https://hub.docker.com/r/luizcarlosfaria/confluence/)


[![Dockerfile 6.4.3](https://img.shields.io/badge/Dockerfile-v6.4.3-lightgray.svg?style=flat)](https://github.com/docker-gallery/confluence/blob/v6.4.3/Dockerfile)


## How to use this image

```
docker run -d \
--name customConfluence \
--hostname customConfluence \
-p 80:8090 \
-v /some/confluence:/var/atlassian/application-data/confluence/ \
luizcarlosfaria/confluence:6.9.0
```

## Volumes
* "/var/atlassian/application-data/confluence/" - Jira Data Home
* "/opt/atlassian/jira/" - Jira Install Home

## Based on [openjdk:8](https://hub.docker.com/_/openjdk/) image
This image is based on openjdk:8 official image.
