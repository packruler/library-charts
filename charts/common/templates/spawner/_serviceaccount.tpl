{{/*
Renders the serviceAccount objects required by the chart.
*/}}
{{- define "common.spawner.serviceaccount" -}}
  {{- /* Generate named serviceAccount as required */ -}}
  {{- range $name, $serviceAccount := .Values.serviceAccount }}
    {{- if $serviceAccount.enabled -}}
      {{- $saValues := $serviceAccount -}}

      {{/* set the default nameOverride to the serviceAccount name */}}
      {{- if and (not $saValues.nameOverride) (ne $name (include "common.lib.util.service.primary" $)) -}}
        {{- $_ := set $saValues "nameOverride" $name -}}
      {{ end -}}

      {{- $_ := set $ "ObjectValues" (dict "serviceAccount" $saValues) -}}
      {{- include "common.class.serviceAccount" $ }}
    {{- end }}
  {{- end }}
{{- end }}
