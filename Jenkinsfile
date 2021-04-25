#! groovy

pipeline {
    environment {
       lib = null
       config = null
    }
    agent {
      kubernetes {
         defaultContainer 'ci'
         yaml """\
           apiVersion: v1
           kind: Pod
           metadata:
             labels:
               "app": "ci"
               namespace: jenkins
           spec:
             containers:
               - name: ci
                 image: ci
                 command: ['docker', 'run', '-p', '80:80', 'httpd:latest']
                 env:
                 - name: DOCKER_HOST
                   value: tcp://localhost:2375
                 imagePullPolicy: Never
          """.stripIndent()
       }
    }
    stages {
        stage('Unit tests') {
            parallel {
                stage('flake8') {
                    steps{
                        cleanWs()
                        dir ('unit-tests'){
                            sh './run python:3.7 flake8'
                        }
                    }
                }
                stage('py38') {
                    steps{
                        cleanWs()
                        dir ('unit-tests'){
                            sh './run python:3.8 py38'
                        }
                    }
                }
            }
        }
    }
}
