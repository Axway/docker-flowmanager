# Flowmanager Deployment on Kubernetes

## Prerequisites

* Kubernetes 1.17+
* Helm 2.16+ / Helm 3+

## Content

* [Flowmanager deployment](flowmanager/README.md)
* [Mongodb deployment](mongodb/README.md)
* [Redis deployment](redis-ha/README.md)

**Caution for redis and mongodb you need to accept the usage of external docker images not under Axway responsability.**

### Internal Mongodb on Kubernetes

**Caution internal mongodb will be not encrypted with certificate**

1. **Helm deployment**

```shell
helm install flowmanager-mongodb -f mongodb.yaml bitnami/mongodb --namespace=<your_namespace>
```

2. **Helm update**

```shell
helm upgrade --install flowmanager-mongodb -f mongodb.yaml bitnami/mongodb --namespace=<your_namespace>
```

3. **Helm delete**

```shell
helm delete flowmanager-mongodb --namespace=<your_namespace>
```

### Internal Redis on Kubernetes

**Caution internal redis will be not encrypted with certificate**

1. **Helm deployment**

```shell
helm install flowmanager-redis -f redis.yaml bitnami/redis --namespace=<your_namespace>
```

2. **Helm update**

```shell
helm upgrade --install flowmanager-redis -f redis.yaml bitnami/redis --namespace=<your_namespace>
```

3. **Helm delete**

```shell
helm delete flowmanager-redis --namespace=<your_namespace>
```

### Flowmanager

1. **Helm deployment**

```shell
helm install  flowmanager ./flowmanager --namespace=<your_namespace> -f flowmanager.yaml
```

3. **Helm update**

```shell
helm upgrade --install flowmanager ./flowmanager --namespace=<your_namespace> -f flowmanager.yaml
```

4. **Helm delete**

```shell
helm delete flowmanager --namespace=<your_namespace>
```
