{{/*
This template serves as a blueprint for all secret objects that are created
within the common library.
*/}}
{{- define "tc.common.v10.class.secret" -}}
  {{- $fullName := include "tc.common.v10.names.fullname" . -}}
  {{- $secretName := $fullName -}}
  {{- $values := .Values.secret -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.secret -}}
      {{- $values = . -}}
    {{- end -}}
  {{ end -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $secretName = printf "%v-%v" $secretName $values.nameOverride -}}
  {{- end }}
---
apiVersion: v1
kind: secret
metadata:
  name: {{ $secretName }}
  {{- with (merge ($values.labels | default dict) (include "tc.common.v10.labels" $ | fromYaml)) }}
  labels: {{- toYaml . | nindent 4 }}
  {{- end }}
  {{- with (merge ($values.annotations | default dict) (include "tc.common.v10.annotations" $ | fromYaml)) }}
  annotations:
    {{- tpl ( toYaml . ) $ | nindent 4 }}
  {{- end }}
stringData:
{{- with $values.data }}
  {{- tpl (toYaml .) $ | nindent 2 }}
{{- end }}
{{- end }}
