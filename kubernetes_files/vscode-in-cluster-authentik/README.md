### WIP how to deploy
minikube start
minikube addons enable ingress
helm install vscode-dev ./vscode-in-cluster-authentik --namespace code-dev --create-namespace \
  --set developerCount=2 \
  --set nginx.domain=vscode.local
helm repo add authentik https://charts.goauthentik.io
helm repo update
kubectl create secret generic authentik-secrets -n code-dev \
  --from-literal=secret_key=$(openssl rand -base64 32) \
  --from-literal=postgresql_password=$(openssl rand -base64 24) \
  --from-literal=redis_password=$(openssl rand -base64 24)
 export PASSWORD=$(kubectl get secret --namespace "code-dev" authentik-postgresql -o jsonpath="{.data.password}" | base64 -d)