# `ghcr.io/majodev/gocryptfs`

Mounts a [rfjakob/gocryptfs](https://github.com/rfjakob/gocryptfs) `$PASSWD` encrypted filesystem at `$ENC_PATH` (default `/encrypted`) to `$DEC_PATH` (default `/decrypted`).

## Usage with Kubernetes

```bash
git clone https://github.com/majodev/gocryptfs.git
cd gocryptfs/deploy

# Set up a sample namespace...
kubectl apply -f namespace.yml

# Ensure to change the secret within
kubectl apply -f secret.yml

# Initialize the encrypted folder
kubectl apply -f init-encrypted.job.yml

# Start an application utilizing the encrypted folder
kubectl apply -f runner.deployment.yml

# ensure to save the config file (holding the masterkey!) locally so you have it in case of file corruption!
kubectl cp <runner-pod>:/encrypted/mnt/gocryptfs.conf ./gocryptfs.conf -c mounter
```

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
  ghcr.io/majodev/gocryptfs sh

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
  ghcr.io/majodev/gocryptfs

docker ps
docker exec -it <container-id> sh

# inside the container
cd decrypted
echo "hi" > test
```
