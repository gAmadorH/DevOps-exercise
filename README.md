
# DevOps exercise

## Dockerfile

Dockerfile was fixed

```dockerfile
FROM php:7.3-apache
ENV MESSAGE="Default message"
COPY src/ /var/www/html/
EXPOSE 80
```

## Build image

And image was build with the `docker-exercise:1` tag

```bash
docker build -t docker-exercise:1 . 
```

Build output:

![Alt text](images/1-build.png?raw=true "Build output")

## Run locally

Using `8080` local port

```bash
docker run -p 8080:80 docker-exercise:1
```

Default message output:

![Alt text](images/2-Default-message.png?raw=true "Default message")

## Change MESSAGE env var

Rerun container other `MESSAGE` env var

```bash
docker run -p 8080:80 -e MESSAGE='Hello World' docker-exercise:1  
```

Hello World output:

![Alt text](images/3-Hello-World.png?raw=true "Hello World")

## Push to Docker Hub

Tag and push image to registry

```bash
docker login -u gamadorh1993
docker tag docker-exercise:1 gamadorh1993/docker-exercise:1
docker push gamadorh1993/docker-exercise:1
```

image in registry:

https://hub.docker.com/repository/docker/gamadorh1993/docker-exercise

## Create Deployment

Deployment manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: apache-deployment
  labels:
    app: apache
spec:
  replicas: 4
  selector:
    matchLabels:
      app: apache
  template:
    metadata:
      labels:
        app: apache
    spec:
      containers:
      - name: apache
        image: gamadorh1993/docker-exercise:1
        ports:
        - containerPort: 80
```

## Create NodePort Service

Service manifest (NodePort type)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service-by-port
spec:
  type: NodePort
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30000
  selector:
    app: apache
```

## Create Ingress

first, ClusterIp service was create

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service-by-ip
spec:
  ports:
  - port: 8080
    targetPort: 80
  selector:
    app: apache
```

And then and Ingress manifest was created

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service-by-ip
            port:
              number: 8080
```

## Resources

All resources created in the cluster:

![Alt text](images/4-commands.png?raw=true "resources")


## URLs

NodePort service:

http://137.184.187.180:30000/

Ingress:

http://137.184.247.199/