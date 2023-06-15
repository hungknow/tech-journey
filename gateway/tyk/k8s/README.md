```
$ kubectl apply -f .
configmap/tyk-gateway-conf created
deployment.apps/tyk-gtw created
service/tyk-svc created
deployment.apps/redis created
service/redis created
```

Check logs to ensure its running
```
$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
redis-7bb4df7c8c-2565f    1/1     Running   0          36s
tyk-gtw-bb7b74677-k9jx9   1/1     Running   0          36s

$ kubectl logs tyk-gtw-bb7b74677-k9jx9

...
time="Dec 04 19:19:39" level=info msg="API Loaded" api_id=1 api_name="Tyk Test API" org_id=default prefix=gateway server_name=-- user_id=-- user_ip=--
time="Dec 04 19:19:39" level=info msg="Loading uptime tests..." prefix=host-check-mgr
time="Dec 04 19:19:39" level=info msg="Initialised API Definitions" prefix=main
time="Dec 04 19:19:39" level=info msg="API reload complete" prefix=main
```

To access the gateway run $ kubectl port-forward svc/tyk-svc 8080:8080
