{{/*
Resolve the values-repo directory that holds addon-specific configuration files.
The default preserves the historical gen3-gitops layout:
  <cluster>/cluster-values/<addon>.yaml
*/}}
{{- define "cluster-level-resources.configurationBasePath" -}}
{{- $basePath := default (printf "%s/cluster-values" .Values.cluster) .Values.configuration.configurationBasePath -}}
{{- trimSuffix "/" $basePath -}}
{{- end -}}
