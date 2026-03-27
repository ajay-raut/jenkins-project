pipeline {
    agent {
        node {
            label 'builtinubuntu'
        }
    }

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform Action')
    }

    environment {
        // Reference the ID you created in Jenkins Credentials
        AWS_ACCESS_KEY_ID     = credentials('terraform-aws-cred')
        AWS_SECRET_ACCESS_KEY = credentials('terraform-aws-cred')
        TF_IN_AUTOMATION      = 'true'
    }
    stages {
        stage('Checkout') {
            steps {
                // Clones the repo where this "Jenkinsfile" resides
                git branch: 'main', url: 'https://github.com/ajay-raut/jenkins-project.git'
            }
        }
        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
            }
        }
        stage('Terraform Run') {
            steps {
                script {
                    if (params.ACTION == 'destroy') {
                        sh 'terraform destroy -auto-approve'
                    } else if (params.ACTION == 'apply') {
                        sh 'terraform apply -auto-approve'
                    } else {
                        sh 'terraform plan'
                    }
                }
            }
        }
        // stage('Terraform Apply') {
        //     // Manual approval is a best practice for production
        //     input {
        //         message "Apply these changes?"
        //         ok "Yes"
        //     }
        //     steps {
        //         sh 'terraform apply -auto-approve tfplan'
        //     }
        // }
    }
}