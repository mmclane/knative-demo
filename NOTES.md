

For production purposes, it is recommended that:

If you have only one node in your cluster, you need at least 6 CPUs, 6 GB of memory, and 30 GB of disk storage.
If you have multiple nodes in your cluster, for each node you need at least 2 CPUs, 4 GB of memory, and 20 GB of disk storage.
You have a cluster that uses Kubernetes v1.24 or newer.
You have installed the kubectl CLI.
Your Kubernetes cluster must have access to the internet, because Kubernetes needs to be able to fetch images. To pull from a private registry, see Deploying images from a private container registry.


## Knative Serving
With the Knative Serving component installed you'll have the ability to: One, automatically deploy applications with public routes in one hit. Two, maintain point in time snapshots of deployments. Three, configure automatic pod scaling, including scale to zero and four, perform traffic splitting enabling blue green deployments.

A Knative Service is distinct and different to the standard Kubernetes Service.

## Knative Eventing
With Knative eventing you can set three primary usage patterns, Source to sink (or fire and forget), Channel and subscription, or Broker and trigger (basically channel and subscription with filtering)

### Knative Eventing Sources
software components that emit events. The job of a Source is to connect to, drain, capture and potentially buffer events; often from an external system and then relay those events to the Sink.



## External Learning Resources
- https://redhat-developer-demos.github.io/knative-tutorial/knative-tutorial/setup/minikube.html
    - Start with this tutorial on basic setup and usage.
- https://knative.dev/docs/getting-started/
    - Use this for instruction on how to create a new function pod and all that.

## Outstanding questions
- Can we setup knative eventing to work with a bull queue?
