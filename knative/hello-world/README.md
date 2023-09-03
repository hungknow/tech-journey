```sh
docker build -t <docker_username>/helloworld-go:latest .
docker push <docker_username>helloworld-go:latest
```

```sh
kubectl apply -f ./service.yaml
```

```sh
kubectl get ksvc helloworld-go
kubectl describe ksvc helloworld-go
```

# Deletion
```sh
kubectl delete -f ./service.yaml
```