pipeline {
  agent any
  stages {
    stage('pull latest terraform') {
      parallel {
        stage('pull latest terraform') {
          steps {
            sh 'printenv'
            sh 'docker pull ${DOCKER_IMAGE}'
          }
        }
        stage('version') {
          steps {
            sh 'docker run -i --rm ${DOCKER_IMAGE} version'
          }
        }
        stage('validate') {
          steps {
            dir(path: "${MODULE_DIR}") {
              sh """
                ${TERRAFORM_CMD} validate -no-color -check-variables=false .
                ${TERRAFORM_CMD} init -no-color -backend=true -input=false
                ${TERRAFORM_CMD} get
               
                                  """
            }

          }
        }
      }
    }
  }
  environment {
    DOCKER_IMAGE = 'hashicorp/terraform:light'
    MODULE_DIR = 'test_uuid'
    TERRAFORM_CMD = 'docker run --rm  --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app ${DOCKER_IMAGE}'
  }
}