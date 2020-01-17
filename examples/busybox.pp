

kubernetes_namespace { 'puppet-test': 
  ensure => present,
}
->
kubernetes_config_map { 'without-namespace-no-md-name':
  metadata => {
    namespace => 'puppet-test',
  },
  data => {
    'pouet' => 'toto1',
    'titi' => 'est la'
  }
}
->
kubernetes_config_map { 'puppet-test::with-namespace-no-md':
  data => {
    'damned' => 'toto2'
  }
}
->
kubernetes_config_map { 'puppet-test::with-namespace-with-md':
  metadata => {
    namespace => 'puppet-test',
    name => 'with-namespace-with-md'
  },
  data => {
    'pouet' => 'toto3',
    'zorro' => 'wasnt there'
  }
}
->
# kubernetes_config_map { 'puppet-test::with-namespace-different-name':
#   metadata => {
#     namespace => 'puppet-test',
#     name => 'something-else'
#   },
#   data => {
#     'pouet' => 'toto4'
#   }
# }
# ->
kubernetes_config_map { 'puppet-test::no-namespace-with-md':
  metadata => {
    name => 'no-namespace-with-md'
  },
  data => {
    'pouet' => 'toto4'
  }
}
->
# this can't work, as we require a namespace
kubernetes_config_map { 'default::no-namespace':
  metadata => {
    name => 'no-namespace'
  },
  data => {
    'pouet' => 'toto2'
  }
}
->
kubernetes_config_map { 'different-name':
  metadata => {
    name => 'real-name',
    namespace => 'puppet-test'
  },
  data => {
    'pouet' => 'toto5',
    'titi' => 'tata'
  }
}


# kubernetes_deployment { 'hello-world':
#   ensure   => present,
#   metadata => {
#     name => 'hello-world',
#     namespace => 'default',
#     labels => {
#       'app' => 'hello-world'
#     }
#   },
#   spec     => {
#     selector => {
#       matchLabels => {
#         app => 'hello-world'
#       }
#     },
#     template => {
#       metadata => {
#         name => 'hello-world',
#         namespace => 'default',
#         labels => {
#           'app' => 'hello-world'
#         },
#         'annotations' => {
#           'ad.datadoghq.com/app.check_names'  => '["openmetrics","toto"]',
#           'ad.datadoghq.com/app.init_configs' => '[{}]',
#         },
#       },
#       spec => {
#         containers => [{
#           name  => 'trucmuch',
#           image => 'bidule',
#           env => [
#             {
#               'name' => 'bidule2',
#               'value' => 'machin3'
#             },
#           ]
#         },{
#           name  => 'hello-world',
#           image => 'gcr.io/hello-minikube-zero-install/hello-node',
#           env => [
#             {
#               'name' => 'toto',
#               'value' => 'VALUE'
#             },
#             {
#               'name' => 'TEST4',
#               'value' => 'VALUE2'
#             },
#           ]
#         }]
#       }
#     }
#   },
# }

# apiVersion: apps/v1
# kind: Deployment
# metadata:
#   name: nginx-deployment
#   labels:
#     app: nginx
# spec:
#   replicas: 3
#   selector:
#     matchLabels:
#       app: nginx
#   template:
#     metadata:
#       labels:
#         app: nginx
#     spec:
#       containers:
#       - name: nginx
#         image: nginx:1.7.9
#         ports:
#         - containerPort: 80

kubernetes_secret {
  "secret":
    metadata => {
      namespace => 'default',
    },
    type => 'Opaque',
    data => {
      'pouet' => 'toto',
      'tutu' => 'titi'
    }
}
