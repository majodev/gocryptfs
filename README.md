# gocryptfs

Dockerized [rfjakob/gocryptfs](https://github.com/rfjakob/gocryptfs)

A fork of [vmirage/docker-gocryptfs](https://github.com/vmirage/docker-gocryptfs) to explicitly test gocryptfs setups within Kubernetes.

## Usage with Kubernetes

See [`./deploy`](./deploy) folder for a sample setup.

## Usage with Docker

```bash
# init
export PASSWD=d9063c35-b341-4fc0-9076-93f97ed76891

# execute into container:
docker run -it \
  --privileged \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -e PASSWD=$PASSWD \
  -v ./.encrypted/test:/encrypted/test \
  ghcr.io/majodev/gocryptfs:<tag> sh

# initialize the encrypted folder inside the container
gocryptfs -init -allow_other -nosyslog -fg -extpass 'printenv PASSWD' /encrypted/test


# then
docker run -d \
  --restart=unless-stopped \
  --privileged \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -e PASSWD=$PASSWD \
  -v ./.encrypted/test:/encrypted/test \
  ghcr.io/majodev/gocryptfs:<tag>
```