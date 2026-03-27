pipeline {
    agent {
        node {
            label 'builtinubuntu'
        }
    }

        triggers {
        pollSCM('H/5 * * * *')
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
        stage('Terraform Apply') {
            // Manual approval is a best practice for production
            input {
                message "Apply these changes?"
                ok "Yes"
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }
}