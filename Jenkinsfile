pipeline {
    agent any
    tools {
        terraform 'terraform'
    }
    stages {
        stage ('terraform init') {
            steps {
                sh 'terraform init'
            }
        }
        stage ('terraform fmt') {
            steps {
                sh 'terraform fmt -recursive'
            }
        }

    }
}
