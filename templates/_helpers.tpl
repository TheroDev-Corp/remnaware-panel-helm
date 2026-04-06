{{/* Expand the name of the chart. */}}
{{- define "remnaware.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Create a default fully qualified app name. */}}
{{- define "remnaware.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Common labels */}}
{{- define "remnaware.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/name: {{ include "remnaware.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Получить имя секрета JWT */}}
{{- define "remnaware.secretName.jwt" -}}
{{- if .Values.secrets.jwt.existingSecret -}}
    {{- .Values.secrets.jwt.existingSecret -}}
{{- else -}}
    {{- include "remnaware.fullname" . }}-jwt
{{- end -}}
{{- end -}}

{{/* Получить имя секрета Telegram */}}
{{- define "remnaware.secretName.telegram" -}}
{{- if .Values.secrets.telegram.existingSecret -}}
    {{- .Values.secrets.telegram.existingSecret -}}
{{- else -}}
    {{- include "remnaware.fullname" . }}-telegram
{{- end -}}
{{- end -}}

{{/* Получить имя секрета Metrics/Webhook */}}
{{- define "remnaware.secretName.metrics" -}}
{{- if .Values.secrets.metrics.existingSecret -}}
    {{- .Values.secrets.metrics.existingSecret -}}
{{- else -}}
    {{- include "remnaware.fullname" . }}-metrics
{{- end -}}
{{- end -}}
{{/* Получить имя секрета внешней БД */}}
{{- define "remnaware.secretName.database" -}}
{{- if .Values.secrets.database.existingSecret -}}
    {{- .Values.secrets.database.existingSecret -}}
{{- else -}}
    {{- include "remnaware.fullname" . }}-external-db
{{- end -}}
{{- end -}}