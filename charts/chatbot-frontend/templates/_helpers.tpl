{{- define "chatbot-frontend.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "chatbot-frontend.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- $release := .Release.Name -}}
{{- printf "%s-%s" $release $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "chatbot-frontend.labels" -}}
app.kubernetes.io/name: {{ include "chatbot-frontend.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: Helm
{{- end -}}