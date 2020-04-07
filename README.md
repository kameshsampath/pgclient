# PostgreSQL Client Sidecar

```shell
 minikube -p postgresql --memory 10000 --cpus 4 --disk-size 50g start
```

## Create configmap for test sql:

```shell
kubectl create cm appsql --from-file=schema.sql=k8s/schema.sql
```

## Deploy Postgresql

```shell
kubectl apply -f k8s/
```

## Load the test schema

Load the schema to have some logs generated:

```shell
kubectl exec $(kubectl get pods --selector=app=postgresql -ojsonpath='{.items[0].m
etadata.name}') -c client \
  -- psql -h localhost -U demo -d gamedb -w -f /opt/sql/schemas/schema.sql
```

## Generate Report via LogAnalyzer

```shell
kubectl exec $(kubectl get pods --selector=app=postgresql -ojsonpath='{.items[0].m
etadata.name}') -c client -- /usr/libexec/genReports.sh
```

## View the report

```shell
minikube -p postgresql service postgresql
```