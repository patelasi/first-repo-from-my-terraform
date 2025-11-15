pipeline {
    agent any

    environment {
        AWS_REGION = 'us-west-2'
        TF_DIR = '.'
    }

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Terraform action to perform')
        booleanParam(name: 'AUTO_APPROVE', defaultValue: false, description: 'Auto-approve terraform apply')
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    echo 'Checking out source code from repository...'
                    checkout scm
                }
            }
        }

        stage('Initialize Terraform') {
            steps {
                script {
                    echo 'Initializing Terraform...'
                    sh 'cd ${TF_DIR} && terraform init'
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                script {
                    echo 'Checking Terraform format...'
                    sh 'cd ${TF_DIR} && terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                script {
                    echo 'Validating Terraform configuration...'
                    sh 'cd ${TF_DIR} && terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    echo 'Running Terraform plan...'
                    sh 'cd ${TF_DIR} && terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    return params.ACTION == 'apply'
                }
            }
            steps {
                script {
                    echo 'Running Terraform apply...'
                    if (params.AUTO_APPROVE) {
                        sh 'cd ${TF_DIR} && terraform apply -auto-approve tfplan'
                    } else {
                        input 'Do you want to apply the terraform plan?'
                        sh 'cd ${TF_DIR} && terraform apply -auto-approve tfplan'
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            when {
                expression {
                    return params.ACTION == 'destroy'
                }
            }
            steps {
                script {
                    echo 'Running Terraform destroy...'
                    input 'Are you sure you want to destroy all resources?'
                    sh 'cd ${TF_DIR} && terraform destroy -auto-approve'
                }
            }
        }
    }

    post {
        always {
            script {
                echo 'Cleaning up workspace...'
                cleanWs()
            }
        }
        success {
            script {
                echo 'Pipeline executed successfully!'
            }
        }
        failure {
            script {
                echo 'Pipeline failed! Please check the logs.'
            }
        }
    }
}
