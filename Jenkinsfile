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
                 image: nexus-docker.edbosetest.com/ci:latest
                 command: ['docker', 'run', '-p', '80:80', 'httpd:latest']
                 imagePullPolicy: Always
                 securityContext:
                   privileged: true
                 env:
                 - name: POD_IP
                   valueFrom:
                   fieldRef:
                     fieldPath: status.podIP
                 - name: DOCKER_HOST
                   value: tcp://localhost:2375
               - name: dind
                 image: docker:18.05-dind
                 securityContext:
                   privileged: true
                 volumeMounts:
                   - name: dind-storage
                     mountPath: /var/lib/docker
             imagePullSecrets:
               - name: nexus-pull-secret
             volumes:
               - name: dind-storage
                 emptyDir: {}
          """.stripIndent()
       }
    }
    stages {
        stage('Unit tests') {
            parallel {
                stage('flake8') {
                    steps{
                        dir ('unit-tests'){
                            sh './run python:3.7 flake8'
                        }
                    }
                }
                stage('py38') {
                    steps{
                        dir ('unit-tests'){
                            sh './run python:3.8 py38'
                        }
                    }
                }
                stage('py37') {
                    steps{
                        dir ('unit-tests'){
                            sh './run python:3.7 py37'
                        }
                    }
                }
                stage('py36') {
                    steps{
                        dir ('unit-tests'){
                            sh './run python:3.6 py36'
                        }
                    }
                }
                stage('py35') {
                    steps{
                        dir ('unit-tests'){
                            sh './run python:3.5 py35'
                        }
                    }
                }
            }
        }
    }
}
