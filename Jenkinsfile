pipeline {
  agent {
    docker {
      image 'hashicorp/terraform'
      args '-v ${PWD}:/app -w /app -it --entrypoint=/bin/sh'
    }

  }
  stages {
    stage('pull latest terraform') {
      steps {
        sh 'docker pull hashicorp/terraform'
      }
    }
  }
  environment {
    CI = 'true'
  }
}