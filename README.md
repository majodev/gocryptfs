# `ghcr.io/majodev/gocryptfs`

Mounts a [rfjakob/gocryptfs](https://github.com/rfjakob/gocryptfs) `$PASSWD` encrypted filesystem at `$ENC_PATH` (default `/encrypted`) to `$DEC_PATH` (default `/decrypted`).

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
  -v ./.encrypted:/encrypted \
  ghcr.io/majodev/gocryptfs:<tag> sh

# initialize the encrypted folder inside the container
gocryptfs -init -allow_other -nosyslog -fg -extpass 'printenv PASSWD' /encrypted

# then
docker run -d \
  --restart=unless-stopped \
  --privileged \
  --cap-add SYS_ADMIN \
  --device /dev/fuse \
  -e PASSWD=$PASSWD \
  -v ./.encrypted:/encrypted \
  ghcr.io/majodev/gocryptfs:<tag>

docker ps
docker exec -it <container-id> sh

# inside the container
cd decrypted
echo "hi" > test
```
