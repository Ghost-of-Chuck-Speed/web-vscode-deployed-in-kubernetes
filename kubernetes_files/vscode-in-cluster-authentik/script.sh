#!/bin/bash

# Fetch secrets
SECRET_KEY=$(kubectl get secret -n code-dev authentik-secrets -o jsonpath="{.data.secret_key}" | base64 --decode)
POSTGRESQL_PASSWORD=$(kubectl get secret -n code-dev authentik-secrets -o jsonpath="{.data.postgresql_password}" | base64 --decode)
REDIS_PASSWORD=$(kubectl get secret -n code-dev authentik-secrets -o jsonpath="{.data.redis_password}" | base64 --decode)

# Create new YAML file with actual values
cat << EOF > authentik-values-filled.yaml
authentik:
  secret_key: "${SECRET_KEY}"
  postgresql:
    password: "${POSTGRESQL_PASSWORD}"
  redis:
    password: "${REDIS_PASSWORD}"

  ingress:
    enabled: true
    hosts:
      - host: auth.vscode.local
        paths:
          - path: /
            pathType: Prefix
    ingressClassName: nginx

server:
  ingress:
    enabled: false
EOF

echo "Created authentik-values-filled.yaml with actual secret values."
