[
  {
    "name": "${backend_container_name}",
    "image": "${backend_ecr_image_url}",
    "cpu": 512,
    "memory": 1024,
    "environment": [
      {
        "name": "PORT",
        "value": "4000"
      },
      {
        "name": "JWT_ACCESSTOKEN_KEY",
        "value": "iuasoiduuqiwjeoqiejo"
      },
      {
        "name": "JWT_REFRESHTOKEN_KEY",
        "value": "alksjdoijoqwijeoijoaidjozisjdiuhqiwejoqwjozsihodznsioaisjdo"
      },
      {
        "name": "EMAIL_NAME",
        "value": "tranvix.work@gmail.com"
      },
      {
        "name": "EMAIL_PASSWORD",
        "value": "lcqp oyvk vsfd ugfv"
      },
      {
        "name": "NODE_ENV",
        "value": "production"
      }
    ],
    "secrets": [
      {
        "name": "MONGO_CONNECTION",
        "valueFrom": "${mongodb_connection_string_secret_arn}"
      }
    ],
    "portMappings": [
      {
        "containerPort": 4000,
        "hostPort": 4000,
        "protocol": "tcp",
        "appProtocol": "http"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${awslogs_group}",
        "awslogs-region": "${awslogs_region}",
        "awslogs-stream-prefix": "${backend_container_name}"
      }
    }
  }
]
