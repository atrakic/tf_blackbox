pipeline {
    agent {
        node {
            label 'build'
        }
    }
    def DOCKER_IMAGE = 'hashicorp/terraform:light'
    environment {
        TERRAFORM_CMD = 'docker run --network host -w /app -v ${HOME}/.aws:/root/.aws -v ${HOME}/.ssh:/root/.ssh -v `pwd`:/app ${DOCKER_IMAGE}'
    }
    stages {
        stage('checkout repo') {
            steps {
              checkout scm
            }
        }
        stage('pull latest light terraform image') {
            steps {
                sh  """
                    docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1 || docker pull ${DOCKER_IMAGE}
                    """
            }
        }
        stage('init') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} init -backend=true -input=false
                    """
            }
        }
                stage('plan') {
            steps {{
                sh  """
                    ${TERRAFORM_CMD} plan -out=tfplan -input=false 
                    """
                script {
                  timeout(time: 10, unit: 'MINUTES') {
                    input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                  }
                }
            }
        }
        stage('apply') {
            steps {
                sh  """
                    ${TERRAFORM_CMD} apply -lock=false -input=false tfplan
                    """
        }
        }
    }
}
