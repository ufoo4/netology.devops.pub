{{- define "db_envs" -}}
- name: POSTGRES_PASSWORD
  value: {{ .Values.environment.POSTGRES_PASSWORD }}
- name: POSTGRES_USER
  value: {{ .Values.environment.POSTGRES_USER }}
- name: POSTGRES_DB
  value: {{ .Values.environment.POSTGRES_DB }}
- name: PGDATA
  value: {{ .Values.environment.PGDATA }}
{{- end }}

{{- define "back_envs" -}}
- name: DATABASE_URL
  value: {{ .Values.environment.DATABASE_URL }}
{{- end }}

{{- define "front_envs" -}}
- name: BASE_URL
  value: {{ .Values.environment.BASE_URL }}
{{- end }}
