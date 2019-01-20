pipeline {
  agent any
  stages {
    stage('pull latest terraform') {
      parallel {
        stage('pull latest terraform') {
          steps {
            sh 'docker pull hashicorp/terraform'
          }
        }
        stage('version') {
          steps {
            sh 'docker run -i --rm ${DOCKER_IMAGE} version'
          }
        }
      }
    }
  }
  environment {
    DOCKER_IMAGE = 'hashicorp/terraform:light'
    MODULE_DIR = 'test_uuid'
  }
}