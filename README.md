# Remnaware Panel Helm Chart

This Helm chart simplifies the deployment of the **Remnawave Panel Backend** on Kubernetes. It includes built-in support for high-availability database management via CloudNativePG and caching with Valkey.

> [!NOTE]
> Based on the original project: [remnawave/backend](https://github.com/remnawave/backend)

## 🚀 Features

- **Remnawave Backend**: The core engine for managing Xray-core proxy environments.
- **CloudNativePG (CNPG)**: Managed PostgreSQL cluster with built-in High Availability and backup support.
- **Valkey**: A high-performance, open-source Redis alternative for caching.
- **Ingress Support**: Easy configuration for Traefik, Nginx, or other ingress controllers.
- **Prometheus Monitoring**: Optional `ServiceMonitor` for integration with Prometheus Operator.
- **Secret Management**: Flexible configuration for JWT, Telegram notifications, and Metrics authentication.

## 📋 Prerequisites

- **Kubernetes**: v1.25+
- **Helm**: v3.2.0+
- **CNPG Operator**: The [CloudNativePG Operator](https://cloudnative-pg.io/) must be installed in your cluster if `cnpg.enabled` is set to `true` (default).

## 📥 Installation

### 1. Clone the repository
```bash
git clone https://github.com/TheroDev-Corp/remnaware-panel-helm.git
cd remnaware-panel-helm
```

### 2. Configure Values
Create a custom `my-values.yaml` or modify the existing `values.yaml`. At a minimum, you should set your domain and secrets:

```yaml
config:
  panelDomain: "panel.example.com"
  subPublicDomain: "panel.example.com/api/sub"

secrets:
  jwt:
    authSecret: "your-very-secure-auth-secret"
    apiTokensSecret: "your-very-secure-api-token-secret"
  telegram:
    botToken: "your-bot-token"
```

### 3. Install the Chart
```bash
helm install remnaware-panel ./ -f my-values.yaml
```

## ⚙️ Configuration

The following table lists the most important configurable parameters of the chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `backend.image.tag` | Remnawave Backend version | `2` |
| `config.panelDomain` | Main domain for the panel API | `panel.domain.com` |
| `config.telegramNotificationsEnabled` | Enable Telegram notifications | `false` |
| `cnpg.enabled` | Use CloudNativePG for managed DB | `true` |
| `cnpg.instances` | Number of DB instances (set to 3 for HA) | `1` |
| `cnpg.backup.enabled` | Enable S3 backups (requires S3 credentials) | `false` |
| `cnpg.backup.retentionPolicy` | How long to keep backups | `30d` |
| `valkey.image.tag` | Valkey version | `9-alpine` |
| `ingress.enabled` | Enable Ingress resource | `false` |
| `serviceMonitor.enabled` | Enable Prometheus ServiceMonitor | `false` |

> [!TIP]
> For a full list of configuration options, check the [values.yaml](values.yaml) file.

## 🔐 Secrets Management

You can either provide secrets directly in `values.yaml` or use existing Kubernetes secrets:

- **JWT**: Set `secrets.jwt.existingSecret` to use a pre-created secret (must contain `JWT_AUTH_SECRET` and `JWT_API_TOKENS_SECRET`).
- **Telegram**: Set `secrets.telegram.existingSecret` (must contain `TELEGRAM_BOT_TOKEN`, etc.).
- **External DB**: If you set `cnpg.enabled: false`, you must provide a `DATABASE_URL` via `secrets.database.url` or `secrets.database.existingSecret`.

## 💾 Database Backups (S3)

If `cnpg.enabled: true`, you can enable automated backups to any S3-compatible storage:

1. Create a secret for S3 credentials:
   ```yaml
   apiVersion: v1
   kind: Secret
   metadata:
     name: cnpg-s3-credentials
   type: Opaque
   data:
     ACCESS_KEY_ID: <base64-access-key>
     ACCESS_SECRET_KEY: <base64-secret-key>
   ```

2. Configure backup settings in `values.yaml`:
   ```yaml
   cnpg:
     backup:
       enabled: true
       bucketName: "your-bucket"
       endpointURL: "https://s3.your-region.amazonaws.com"
       existingSecret: "cnpg-s3-credentials"
       retentionPolicy: "30d"
       # backupOwner: "primary" # Uncomment for newer CNPG versions if needed
   ```

## 🗑️ Uninstallation

To remove the deployment and all associated resources:

```bash
helm uninstall remnaware-panel
```

> [!CAUTION]
> This will delete the PostgreSQL cluster and all data if no external persistence or backups are configured.
