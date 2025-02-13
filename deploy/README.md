```bash
kubectl apply -f namespace.yml

# ensure the change the secret within...
kubectl apply -f secret.yml

# Initialize the encrypted folder
kubectl apply -f init-encrypted.job.yml

# Start an application utilizing the encrypted folder
kubectl apply -f runner.deployment.yml

# ensure to save the config file (holding the masterkey!) locally so you have it in case of corruption!
k cp <runner-pod>:/encrypted/test/gocryptfs.conf ./gocryptfs.conf -c mounter
```