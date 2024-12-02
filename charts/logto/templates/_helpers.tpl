{{/*
Expand the name of the chart.
*/}}
{{- define "logto.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "logto.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "logto.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "logto.labels" -}}
helm.sh/chart: {{ include "logto.chart" . }}
{{ include "logto.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "logto.selectorLabels" -}}
app.kubernetes.io/name: {{ include "logto.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Create the database.properties file
*/}}
{{- define "logto.server.databaseProperties" -}}
{{- if .Values.postgresql.enabled }}
connectionProperties.user={{ .Values.postgresql.postgresqlUsername }}
connectionUrl=jdbc\:postgresql\://{{ include "logto.fullname" . }}-postgresql/{{ .Values.postgresql.postgresqlDatabase }}
connectionProperties.password={{ .Values.postgresql.postgresqlPassword }}
{{- else }}
{{ .Values.server.configDb | default "" }}
{{- end }}
{{- end }}

{{/*
Convert a memory resource like "500Mi" to the number 500 (Megabytes)
*/}}
{{- define "resource-mb" -}}
{{- if . | hasSuffix "Mi" -}}
{{- (. | trimSuffix "Mi" | int64) -}}
{{- else if . | hasSuffix "Gi" -}}
{{- mul (. | trimSuffix "Gi" | int64) 1000 -}}
{{- end }}
{{- end }}
