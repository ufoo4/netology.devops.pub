local prod = import './stage.libsonnet';

prod {
  components +: {
    backend +: {
      replicas: 3,
    },
    frontend +: {
      replicas: 3,
    },
    db +: {
      replicas: 3,
    },
    endpoint: {
      address: "92.43.188.80"
    }
  }
}