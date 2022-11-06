{
  components: {

    "backend": {
      "replicas": 1,
      "name": "backend",
      "image": "foo4/13-kub-config-01-obj_src-backend:latest",
      "ports": {
        "containerPort": 9000
      },
      "service": {
        "port": 9000
      }
    },

    "frontend": {
      "replicas": 1,
      "name": "frontend",
      "image": "foo4/13-kub-config-01-obj_src-frontend:latest",
      "ports": {
         "containerPort": 80
      },
      "service": {
         "port": 80
      },
      "endpoint": false
    },

    "db": {
      "replicas": 1,
      "name": "db",
      "image": "postgres:13-alpine",
      "ports": {
         "containerPort": 5432
      },
      "service": {
         "port": 5432
      }
    },
  }
}