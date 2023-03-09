SHELL = /bin/sh
MAKE_PATH=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
FUNCNAME=testing

start:
	minikube start
	sleep 30s
stop:
	minikube stop

install:
	minikube addons enable registry
	
	@echo "### Installing Knative Serving ###"
	@kubectl apply --filename https://github.com/knative/serving/releases/download/knative-v1.9.2/serving-crds.yaml --filename https://github.com/knative/eventing/releases/download/knative-v1.9.2/eventing-crds.yaml
	@kubectl apply --filename https://github.com/knative/serving/releases/download/knative-v1.9.2/serving-core.yaml
	
	@echo '### Install Kourier Ingress Gateway ###'
	@kubectl apply --filename https://github.com/knative/net-kourier/releases/download/knative-v1.9.2/kourier.yaml
	
	@echo '### Configure Knative Serving to use Kourier Ingress Gateway ###'
	@kubectl patch configmap/config-network -n knative-serving --type merge -p '{"data":{"ingress.class":"kourier.ingress.networking.knative.dev"}}'
	
	@echo '### Install Contour Ingress Controller ###'
	@kubectl apply --filename https://projectcontour.io/quickstart/contour.yaml
	
	@echo '### Configure Contour Ingress Controller ###'
	@kubectl apply -f ./k8s-setup/ingress.yaml
	
	@echo '### Configure knative to use kourier-ingress gateway'
	./k8s-setup/setup-nip.sh

	@echo '### Install Knative Eventing ###'
	@kubectl apply --filename https://github.com/knative/eventing/releases/download/knative-v1.9.2/eventing-core.yaml --filename https://github.com/knative/eventing/releases/download/knative-v1.9.2/in-memory-channel.yaml --filename https://github.com/knative/eventing/releases/download/knative-v1.9.2/mt-channel-broker.yaml

	clear

setup: start install

delete:
	minikube delete

done: cleanup delete
	

service:
	kubectl apply -f ./create-service/service.yaml
	@sleep 15s
	@echo ''
	kubectl get deployments

	@echo ''
	@echo ''
 
	@./bin/greeter.sh

	@echo ''
	@echo 'sleeping for 65 seconds'

	@sleep 65s

	kubectl get deployments

scaler:
	kubectl apply -f ./autoscaler/
	
	@echo ''
	@sleep 10s

	kubectl get deployments
	
	@echo ''
	@echo 'Running mini-loadtest:'
	hey -c 50 -z 10s "$(shell kn service describe prime-generator -o url)/?sleep=3&upto=10000&memload=100"

blue:
	@echo '### Create Blue Service ###'
	kubectl apply -f ./blue-green/blue-service.yaml
	@echo ''
	@echo '### Tag Blue Service ###'
	kn service update blue-green-canary --tag=blue-green-canary-00001=blue
	@echo ''
	kn service describe blue-green-canary -o url

green:
	@echo '### Create Green Service ###'
	kubectl apply -f ./blue-green/green-service.yaml
	@echo ''
	@echo '### Tag Green Service ###'
	kn service update blue-green-canary --tag=blue-green-canary-00002=green
	@echo ''
	@echo '### Tag whatever revision is latest as latest ###'
	kn service update blue-green-canary --tag=@latest=latest
	@echo ''
	@sleep 5s
	kn revision list

8020:
	kn service update blue-green-canary --traffic="blue=80" --traffic="green=20"
	kn revision list

yellow:
	@echo '### Create Yellow Service ###'
	kubectl apply -f ./blue-green/yellow-service.yaml
	@echo ''
	@echo '### Tag Yellow Service ###'
	kn service update blue-green-canary --tag=blue-green-canary-00003=yellow
	@echo ''
	kn service update blue-green-canary --traffic="blue=50" --traffic="green=25" --traffic="yellow=25"
	kn revision list

cleanup:
	-kubectl delete -f ./create-service/ 
	-kubectl delete -f ./autoscaler/ 
	-kubectl delete -f ./blue-green/blue-service.yaml
	clear
func:
	-func create -l node $(FUNCNAME)
	cd $(FUNCNAME) && func run --build --registry localhost:5000/knative

deploy:
	kn service list
	@echo ''
	@sleep 5s
	cd $(FUNCNAME) && func deploy --build --registry localhost:5000/knative
	http $(shell kn service describe $(FUNCNAME) -o url) message="Hello World"

	@echo ''
	@sleep 2s
	kn service list
