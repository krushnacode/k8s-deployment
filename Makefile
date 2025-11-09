.PHONY: start build deploy monitor rollback clean

start:
	minikube start --cpus=4 --memory=6g
	minikube addons enable ingress

build:
	eval $$(minikube -p minikube docker-env) && docker build -t sample-node-app:local .

deploy:
	kubectl apply -k k8s
	kubectl -n demo rollout status deploy/web

monitor:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update
	helm upgrade --install prom-stack prometheus-community/kube-prometheus-stack \
		--namespace monitoring --create-namespace \
		-f monitoring/values-prom-stack.yaml
	kubectl -n demo apply -f monitoring/servicemonitor.yaml

rollback:
	kubectl -n demo rollout undo deploy/web

clean:
	kubectl delete ns demo || true
	kubectl delete ns monitoring || true
	minikube delete
