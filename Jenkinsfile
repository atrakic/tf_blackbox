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
            sh 'version'
          }
        }
      }
    }
  }
}