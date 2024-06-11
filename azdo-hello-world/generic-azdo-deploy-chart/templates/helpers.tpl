{{/*
Create the appinstance based on the Release name. The value should be unique within the namespace.
*/}}
{{- define "generic-azdo-deploy-chart.appinstance" -}}
{{- .Release.Name }}
{{- end }}


{{/*
Generate the fullname
*/}}
{{- define "generic-azdo-deploy-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Generate the chart name
*/}}
{{- define "generic-azdo-deploy-chart.name" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "generic-azdo-deploy-chart.selectorLabels" -}}
app.kubernetes.io/instance: {{ include "generic-azdo-deploy-chart.appinstance" . }}
{{- end }}

{{/*
Generate labels
*/}}
{{- define "generic-azdo-deploy-chart.labels" -}}
{{- include "generic-azdo-deploy-chart.selectorLabels" . }}
app.kubernetes.io/name: {{ include "generic-azdo-deploy-chart.name" . }}
helm.sh/chart: {{ include "generic-azdo-deploy-chart.name" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.environment }} 
{{- end -}}

{{/*
Generate annotations
*/}}
{{- define "generic-azdo-deploy-chart.annotation.helm-revision" -}}
app.kubernetes.io/helm-revision: {{ .Release.Revision | quote }}
{{- end -}}

{{/*
Generate resources
*/}}
{{- define "generic-azdo-deploy-chart.resources" -}}
{{- if .Values.resources }}
{{ toYaml .Values.resources | nindent 12 }}
{{- else }}
{}
{{- end -}}
{{- end -}}

{{/*
Generate health probes
*/}}
{{- define "generic-azdo-deploy-chart.probes" -}}
{{- if .Values.healthProbes.enabled }}
  startupProbe:
    httpGet:
      path: {{ $.Values.healthProbes.startupProbe.path }}
      port: {{ $.Values.containerPort }}
    initialDelaySeconds: {{ $.Values.healthProbes.startupProbe.initialDelaySeconds }}
    periodSeconds: {{ $.Values.healthProbes.startupProbe.periodSeconds }}
  livenessProbe:
    httpGet:
      path: {{ $.Values.healthProbes.livenessProbe.path }}
      port: {{ $.Values.containerPort }}
    initialDelaySeconds: {{ $.Values.healthProbes.livenessProbe.initialDelaySeconds }}
    periodSeconds: {{ $.Values.healthProbes.livenessProbe.periodSeconds }}
  readinessProbe:
    httpGet:
      path: {{ $.Values.healthProbes.readinessProbe.path }}
      port: {{ $.Values.containerPort }}
    initialDelaySeconds: {{ $.Values.healthProbes.readinessProbe.initialDelaySeconds }}
    periodSeconds: {{ $.Values.healthProbes.readinessProbe.periodSeconds }}
{{- end -}}
{{- end -}}
