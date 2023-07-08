# Red Hat JBoss EAP on Azure Kubernetes Service (AKS) Kubernetes Service Hello World

This is a simple application that demonstrates a basic deployment of an Java application on Wildfly (JBoss EAP) on Azure Kubernetes Service. The applicatoin is a _properties browser_ type app that you can explore the properties of the deployed app. This makes the app useful for demonstrating the correlation between the actual deployed app and the environment.

## Prerequisites
* [Azure subscription](https://azure.microsoft.com/en-us/free/)
* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli?WT.mc_id=java-9121-yoterada)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)


## Create a new Azure Kubernetes Service (AKS) cluster - 10 min

 * [Quickstart: Deploy an Azure Kubernetes Service (AKS) cluster using Azure CLI](https://learn.microsoft.com/en-us/azure/aks/learn/quick-kubernetes-deploy-cli)

## Install a Wildfly operator - 7 min

 * Install Operator Lifecycle Manager (OLM), a tool to help manage the Operators running on your AKS cluster.

```
curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.25.0/install.sh | bash -s v0.25.0
```

 * Install the operator by running the following command. This Operator will be installed in the "operators" namespace and will be usable from all namespaces in the cluster.

```
$ kubectl create -f https://operatorhub.io/install/wildfly.yaml
```

 * After installation, watch your operator come up using the next command.

```
kubectl get csv -n operators
```

To use it, checkout the custom resource definitions (CRDs) introduced by this operator to start using it.

## Create a Wildfly CR - 7 min

 * Create a wildfly.yaml and copy the following content.

 ```
apiVersion: wildfly.org/v1alpha1
kind: WildFlyServer
metadata:
name: quickstart
spec:
applicationImage: 'quay.io/danieloh30/eap-on-aks-helloworld-main:1.3'
replicas: 2
```

 * Create the wildfly CR.

 ```
 kubectl apply -f wildfly.yaml
 ```

 * Verify the EAP server -  2 min

```
kubectl logs eap-on-aks-helloworld-0
```

 * The output should look like this.

```
...
04:23:31,111 INFO  [org.jboss.as.clustering.infinispan] (ServerService Thread Pool -- 75) WFLYCLINF0002: Started http-remoting-connector cache from ejb container
04:23:32,192 INFO  [org.jboss.resteasy.resteasy_jaxrs.i18n] (ServerService Thread Pool -- 76) RESTEASY002225: Deploying javax.ws.rs.core.Application: class org.jboss.helloworld.RestApplication$Proxy$_$$_WeldClientProxy
04:23:32,280 INFO  [org.wildfly.extension.undertow] (ServerService Thread Pool -- 76) WFLYUT0021: Registered web context: '/helloworld-eap' for server 'default-server'
04:23:32,545 INFO  [org.jboss.as.server] (ServerService Thread Pool -- 42) WFLYSRV0010: Deployed "helloworld-eap.war" (runtime-name : "helloworld-eap.war")
04:23:32,667 INFO  [org.jboss.as.server] (Controller Boot Thread) WFLYSRV0212: Resuming server
04:23:32,673 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0025: JBoss EAP 7.4.11.GA (WildFly Core 15.0.26.Final-redhat-00001) started in 16988ms - Started 521 of 808 services (515 services are lazy, passive or on-demand)
04:23:32,676 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0060: Http management interface listening on http://0.0.0.0:9990/management
04:23:32,676 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0054: Admin console is not enabled
```

 * Edit the service to access by an external client - 2 min

```
kubectl edit svc eap-on-aks-helloworld-loadbalancer
```

 * Update the `spec.ports.port`'s value to `80` and `spec.type`'s value to `LoadBalancer`. Save the resource.

 * Verify the service.

```
kubectl get svc
```

 * The output should look like this.

```
NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)          AGE
eap-on-aks-helloworld-admin          ClusterIP      None           <none>          9990/TCP         27m
eap-on-aks-helloworld-headless       ClusterIP      None           <none>          8080/TCP         27m
eap-on-aks-helloworld-loadbalancer   LoadBalancer   10.0.127.131   20.10.225.209   8080:31127/TCP   27m
``` 

## Access the landing page

Once a new tab in your web browser, access the `EXTERNAL-IP/helloworld-ear`. For example, 20.10.225.209/helloworld-ear.

![Topology view](src/main/webapp/assets/img/eap-aks-landing.png)

## Appendix

How to change the current namespace in Kubernetes.

```
kubectl config set-context --current --namespace=eap-aks
```