{{- define "cluster-level-resources.karpenterNodeConfigApp" -}}
{{- $root := .root -}}
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: karpenter-config-resources-{{ .name }}
  namespace: argocd
spec:
  project: default
  source:
    repoURL: {{ required "karpenterNodeConfigChart.repoURL is required in hub-owned mode" $root.Values.karpenterNodeConfigChart.repoURL }}
    targetRevision: {{ required "karpenterNodeConfigChart.targetRevision is required in hub-owned mode" $root.Values.karpenterNodeConfigChart.targetRevision }}
    path: {{ required "karpenterNodeConfigChart.path is required in hub-owned mode" $root.Values.karpenterNodeConfigChart.path }}
    helm:
      releaseName: karpenter-node-config-{{ .name }}
      values: |
        resourceName: {{ .name | quote }}
        cluster: {{ $root.Values.cluster | quote }}
        cilium:
{{ toYaml $root.Values.cilium | nindent 10 }}
        karpenter:
{{ toYaml $root.Values.karpenter | nindent 10 }}
        karpenter-crds:
{{ toYaml (index $root.Values "karpenter-crds") | nindent 10 }}
  destination:
    server: {{ $root.Values.destinationServer | quote }}
    namespace: karpenter
  syncPolicy:
    syncOptions:
    - CreateNamespace=true
    - ServerSideApply=true
    automated:
      selfHeal: true
{{- end -}}
