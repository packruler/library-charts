{{/* vim: set filetype=mustache: */}}

{{/*
Return a soft nodeAffinity definition
{{ include "tc.common.v10.affinities.nodes.soft" (dict "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "tc.common.v10.affinities.nodes.soft" -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - preference:
      matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
    weight: 1
{{- end -}}

{{/*
Return a hard nodeAffinity definition
{{ include "tc.common.v10.affinities.nodes.hard" (dict "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "tc.common.v10.affinities.nodes.hard" -}}
requiredDuringSchedulingIgnoredDuringExecution:
  nodeSelectorTerms:
    - matchExpressions:
        - key: {{ .key }}
          operator: In
          values:
            {{- range .values }}
            - {{ . | quote }}
            {{- end }}
{{- end -}}

{{/*
Return a nodeAffinity definition
{{ include "tc.common.v10.affinities.nodes" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "tc.common.v10.affinities.nodes" -}}
  {{- if eq .type "soft" }}
    {{- include "tc.common.v10.affinities.nodes.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "tc.common.v10.affinities.nodes.hard" . -}}
  {{- end -}}
{{- end -}}

{{/*
Return a soft podAffinity/podAntiAffinity definition
{{ include "tc.common.v10.affinities.pods.soft" (dict "component" "FOO" "extraMatchLabels" .Values.extraMatchLabels "context" $) -}}
*/}}
{{- define "tc.common.v10.affinities.pods.soft" -}}
{{- $component := default "" .component -}}
{{- $extraMatchLabels := default (dict) .extraMatchLabels -}}
preferredDuringSchedulingIgnoredDuringExecution:
  - podAffinityTerm:
      labelSelector:
        matchLabels: {{- (include "tc.common.v10.labels.matchLabels" .context) | nindent 10 }}
          {{- if not (empty $component) }}
          {{ printf "app.kubernetes.io/component: %s" $component }}
          {{- end }}
          {{- range $key, $value := $extraMatchLabels }}
          {{ $key }}: {{ $value | quote }}
          {{- end }}
      namespaces:
        - {{ .context.Release.Namespace | quote }}
      topologyKey: kubernetes.io/hostname
    weight: 1
{{- end -}}

{{/*
Return a hard podAffinity/podAntiAffinity definition
{{ include "tc.common.v10.affinities.pods.hard" (dict "component" "FOO" "extraMatchLabels" .Values.extraMatchLabels "context" $) -}}
*/}}
{{- define "tc.common.v10.affinities.pods.hard" -}}
{{- $component := default "" .component -}}
{{- $extraMatchLabels := default (dict) .extraMatchLabels -}}
requiredDuringSchedulingIgnoredDuringExecution:
  - labelSelector:
      matchLabels: {{- (include "tc.common.v10.labels.matchLabels" .context) | nindent 8 }}
        {{- if not (empty $component) }}
        {{ printf "app.kubernetes.io/component: %s" $component }}
        {{- end }}
        {{- range $key, $value := $extraMatchLabels }}
        {{ $key }}: {{ $value | quote }}
        {{- end }}
    namespaces:
      - {{ .context.Release.Namespace | quote }}
    topologyKey: kubernetes.io/hostname
{{- end -}}

{{/*
Return a podAffinity/podAntiAffinity definition
{{ include "tc.common.v10.affinities.pods" (dict "type" "soft" "key" "FOO" "values" (list "BAR" "BAZ")) -}}
*/}}
{{- define "tc.common.v10.affinities.pods" -}}
  {{- if eq .type "soft" }}
    {{- include "tc.common.v10.affinities.pods.soft" . -}}
  {{- else if eq .type "hard" }}
    {{- include "tc.common.v10.affinities.pods.hard" . -}}
  {{- end -}}
{{- end -}}
