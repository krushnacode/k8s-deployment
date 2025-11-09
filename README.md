# 🚀 DevOps Assignment — CI/CD + Kubernetes + Monitoring + Security (Minikube)

This project demonstrates a complete DevOps workflow, covering:
- CI/CD automation (GitHub Actions)
- Containerization using Docker
- Kubernetes deployment on Minikube
- Autoscaling with HPA
- Monitoring using Prometheus + Grafana
- Image scanning with Trivy
- Secure configuration using Kubernetes Secrets

✅ The setup can be replicated on **any system** that has Docker, Minikube, and kubectl installed.

## ⚙️ Prerequisites

Before you begin, please install:

| Tool | Purpose | Install Command |
|------|----------|-----------------|
| Docker | Build and run containers | `sudo apt install docker.io -y` |
| Minikube | Local Kubernetes cluster | `sudo apt install minikube -y` |
| kubectl | Manage Kubernetes resources | `sudo snap install kubectl --classic` |
| Helm | Install Prometheus & Grafana | `curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash` |
| Trivy | Security scanning | `sudo apt install trivy -y` |
| Git | Version control | `sudo apt install git -y` |

## 🧩 Setup Instructions

### 1️⃣ Clone the repository

```bash
git clone https://github.com/krushnacode/k8s-deployment.git
cd k8s-deployment

---



```markdown
### 2️⃣ Start Minikube
```bash
minikube start --cpus=4 --memory=6g
minikube addons enable ingress

---

```markdown
### 3️⃣ Build Docker image in Minikube environment
```bash
eval $(minikube docker-env)
docker build -t sample-node-app:local .


### 4️⃣ Deploy to Kubernetes

kubectl apply -k k8s
kubectl -n demo rollout status deploy/web



---

## 4️⃣ Start Minikube and Enable Ingress
## 5️⃣ Build and Deploy Locally
## 6️⃣ Access the App

```markdown
## 🌐 Access the Application

Get the Minikube IP:
```bash
minikube ip

### Add it to your /etc/hosts file:

<MINIKUBE_IP> web.localtest.me


---

## 7️⃣ Monitoring Setup (Prometheus + Grafana)

Let them visualize metrics too:

```markdown
## 📈 Monitoring Setup (Prometheus + Grafana)

Deploy monitoring stack:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prom-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  -f k8s/values-prom-stack.yaml


Apply ServiceMonitor:

kubectl -n demo apply -f k8s/servicemonitor.yaml


Access Grafana:

kubectl -n monitoring port-forward svc/prom-stack-grafana 3001:80



---

## 8️⃣ Security (Trivy + Secrets)

Let them replicate the scanning and see how you handled secrets:

```markdown
## 🛡️ Security

### Trivy Scan
```bash
trivy image sample-node-app:local


---

## 9️⃣ Scaling Test (HPA)

Show how they can test autoscaling manually:

```markdown
## ⚖️ Horizontal Pod Autoscaler (HPA)

Check scaling:
```bash
kubectl -n demo get hpa
kubectl top pods -n demo


kubectl -n demo exec deploy/web -- sh -c "while true; do :; done"



---

## 🔁 Rollback and Cleanup

Give them recovery commands so they don’t break anything.

```markdown
## 🔁 Rollback
If deployment fails:
```bash
make rollback



make clean


---

## 🔧 CI/CD Pipeline Explanation

So they know how to check the `.github/workflows/ci.yml` file.

```markdown
## ⚙️ CI/CD Pipeline (GitHub Actions)

The workflow `.github/workflows/ci.yml` runs automatically on every push to `main`.

It performs:
1. Checkout code
2. Install Node.js dependencies
3. Run tests
4. Build Docker image
5. Scan vulnerabilities with Trivy

This ensures continuous integration and image security checks.



Troubleshooting Section


## 🧠 Troubleshooting

| Issue | Possible Cause | Fix |
|--------|----------------|-----|
| Pods stuck in `ImagePullBackOff` | Image not built in Minikube’s Docker env | Run `eval $(minikube docker-env)` before `docker build` |
| Ingress not accessible | Ingress addon not enabled | Run `minikube addons enable ingress` |
| Grafana not opening | Port not forwarded | Run `kubectl -n monitoring port-forward svc/prom-stack-grafana 3001:80` |


## 🧱 Architecture Diagram (Text Overview)
Developer Push → GitHub Actions (CI/CD)
        ↓
Docker Image Build + Trivy Scan
        ↓
Kubernetes Deployment on Minikube
        ↓
Pods → Service → Ingress (web.localtest.me)
        ↓
Prometheus Scrapes Metrics → Grafana Dashboards