# Docker Ansible ARA Web Front

[![Build Status](https://travis-ci.org/Turgon37/docker-ansible-araweb.svg?branch=master)](https://travis-ci.org/Turgon37/docker-ansible-araweb) [![](https://images.microbadger.com/badges/image/turgon37/ansible-araweb.svg)](https://microbadger.com/images/turgon37/ansible-araweb "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/turgon37/ansible-araweb.svg)](https://microbadger.com/images/turgon37/ansible-araweb "Get your own version badge on microbadger.com")

This image contains an instance of ARA Web Front served by Nginx

:warning: Take care of the [changelogs](CHANGELOG.md) because some breaking changes may happend between versions.

## Supported tags and respective Dockerfile links

## Docker Informations

* This image expose the following port

| Port         | Usage                |
| ------------ | -------------------- |
| 80/tcp       | HTTP web application |

* This image takes theses environnements variables as parameters

| Environment | Type   | Usage                                                          |
| ------------|--------| -------------------------------------------------------------- |
| ARA_API_URL | String | The base URL of the remote ARA API server without ending slash |

* The following volumes are exposed by this image

| Volume | Usage                                                        |
| ------ | ------------------------------------------------------------ |

## Installation

```
docker pull turgon37/ansible-araweb:latest
```

## Usage
