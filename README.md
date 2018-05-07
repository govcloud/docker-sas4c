# SAS for Containers

[SAS4C][sas4c] for containers docker image from the [official source][official].

## Authentication to ACR

Protected under the Azure Container Registry.

```sh
docker login sas4c.azurecr.io
username: xxxxx
password: xxxxx
```

> Note: Azure ACR also supports access to repositories via inherited Active Directory profiles.

## Images

There are three images you can choose from:

* 9.4 (default)
* 9.4-slim (slim)
* 9.4-studio (studio)

## Build

```sh
docker build --build-arg AZURE_ACCOUNT_KEY=${AZURE_ACCOUNT_KEY} -t sas4c:9.4 .
```

## Pull

```sh
docker pull sas4c.azurecr.io/sas4c:9.4
```

## Run

```sh
docker run --name sas -d \
           -p 38080:38080 \
           sas4c:9.4
```

## Exec

```sh
docker exec -it sas4c sh
```

## Volume Mount

```sh
docker run --name sas \
           -v $(pwd):/home/sas -d \
           -p 8561:8561 \
           -p 8591:8591 \
           sas4c:9.4 sas tests/marks.sas
```

## SAS Studio

Access at http://localhost:38080/SASStudio/

```sh
docker run --name sas -d \
           -p 8561:8561 \
           -p 8591:8591 \
           -p 38080:38080 \
           sas4c:9.4-studio
```

[official]:            https://www.sas.com/en_ca/software/analytics-for-containers.html
[sas4c]:               https://github.com/govcloud/docker-sas4c
[registry]:            https://hub.docker.com/r/govcloud/docker-sas4c
