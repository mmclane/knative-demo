minikube start

echo '## Enable registry addon'
minikube addons enable registry

echo '### Install CRDs'
kubectl apply \
  --filename https://github.com/knative/serving/releases/download/knative-v1.9.2/serving-crds.yaml \
  --filename https://github.com/knative/eventing/releases/download/knative-v1.9.2/eventing-crds.yaml

echo '## Install Knative Serving '
kubectl apply \
  --filename \
  https://github.com/knative/serving/releases/download/knative-v1.9.2/serving-core.yaml

echo '## Install Kourier Ingress Gateway'
kubectl apply \
  --filename \
    https://github.com/knative/net-kourier/releases/download/knative-v1.9.2/kourier.yaml

echo '## Configure Knative Serving to use Kourier Ingress Gateway'
kubectl patch configmap/config-network \
  -n knative-serving \
  --type merge \
  -p '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'

echo '## Install Contour Ingress Controller'
kubectl apply \
  --filename https://projectcontour.io/quickstart/contour.yaml

echo '## Configure Contour Ingress Controller'
kubectl apply -f ./k8s-setup/ingress.yaml


ksvc_domain="\"data\":{\""$(minikube ip)".nip.io\": \"\"}"
kubectl patch configmap/config-domain \
    -n knative-serving \
    --type merge \
    -p "{$ksvc_domain}"

echo '## Install Knative Eventing'
kubectl apply \
  --filename \
  https://github.com/knative/eventing/releases/download/knative-v1.9.2/eventing-core.yaml \
  --filename \
  https://github.com/knative/eventing/releases/download/knative-v1.9.2/in-memory-channel.yaml \
  --filename \
  https://github.com/knative/eventing/releases/download/knative-v1.9.2/mt-channel-broker.yaml
