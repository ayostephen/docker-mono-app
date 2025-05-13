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
        stage ('terraform validate') {
            steps {
                sh 'terraform validate'
            }
        }
        
        stage ('terraform plan') {
            steps {
                sh 'terraform plan -var-file="iac.tfvars"'
            }
        }
        stage('Request Approval to apply') {
            steps {
                timeout(activity: true, time: 5) {
                    input message: 'Needs Approval to Apply ', submitter: 'admin'
                }
            }
        }
        stage('terraform action') {
            steps {
                sh 'terraform ${action} -var-file="iac.tfvars" -auto-approve'
            }
        }
    }
}



// null

// pipeline {
//     agent any

//     tools {
//         terraform 'terraform'
//     }

//     environment {
//         // TFVARS_FILE points to the copied file in the tmp directory
//         TFVARS_FILE = '/tmp/iac.tfvars'
//     }

//     parameters {
//         choice(name: 'action', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action to perform')
//     }

//     stages {
//         stage('Load tfvars from Jenkins Credentials') {
//             steps {
//                 withCredentials([file(credentialsId: 'iac-tfvars', variable: 'TFVARS')]) {
//                     // Copy the file from the credential store to the tmp directory
//                     sh 'cp $TFVARS /tmp/iac.tfvars'
//                 }
//             }
//         }

//         stage('Terraform Init') {
//             steps {
//                 sh 'terraform init'
//             }
//         }

//         stage('Terraform Format') {
//             steps {
//                 sh 'terraform fmt -recursive'
//             }
//         }

//         stage('Terraform Validate') {
//             steps {
//                 sh 'terraform validate'
//             }
//         }

//         stage('Terraform Plan') {
//             when {
//                 expression { params.action == 'plan' }
//             }
//             steps {
//                 // Reference the tfvars file from the tmp directory
//                 sh "terraform plan -var-file=\"$TFVARS_FILE\""
//             }
//         }

//         stage('Request Approval') {
//             when {
//                 expression { params.action == 'apply' || params.action == 'destroy' }
//             }
//             steps {
//                 timeout(activity: true, time: 5) {
//                     input message: "Approve to ${params.action}?", submitter: 'admin'
//                 }
//             }
//         }

//         stage('Terraform Apply/Destroy') {
//             when {
//                 expression { params.action == 'apply' || params.action == 'destroy' }
//             }
//             steps {
//                 // Reference the tfvars file from the tmp directory
//                 sh "terraform ${params.action} -var-file=\"$TFVARS_FILE\" -auto-approve"
//             }
//         }
//     }
// }