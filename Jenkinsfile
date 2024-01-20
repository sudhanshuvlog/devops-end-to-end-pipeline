//This pipeline will pull the code from github and then test it, and everytime it will test in a daynamic docker container slave
pipeline {
    agent {label "ec2"}
    stages {
        stage('Git') {
            steps {
                echo 'Downoading..'
                git 'https://github.com/sudhanshuvlog/devops-end-to-end-pipeline.git'
                sh "Code Downloaded Succesfully!"
            }
        }
        stage("Setup Ansible"){
            steps{
                echo "Testing was already done succesfully via Github Workflows"
                sh "yum install ansible -y"
                echo "Ansible Installed"
        }
        }
        stage("Setup Terraform"){
            steps{
                script {
                    if (!fileExists('terraform_1.6.0_linux_amd64.zip')) {
                        sh 'wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip'
                        sh "unzip terraform_1.6.0_linux_amd64.zip"
                        sh "mv terraform /usr/local/bin/"
                    } else {
                        echo 'Terraform zip file already exists. Skipping download.'
                    }
                }
            sh "terraform --version"
            //sh "aws configure set aws_access_key_id "
            //sh  "aws configure set aws_secret_access_key "
            }
        }
        stage("Create Infrastructure for PROD"){
            steps{
            sh "terraform init"
            sh "terraform apply --auto-approve"
            sh "sleep 30" //giving some time for infrastructure to be up and running..
            echo "Infrastructure is up and running.."
            }
        }
        stage("Configure k8s cluster on the created infrastructure "){
            steps{
                sh "chmod 400 mykey"
                sh "ansible-playbook k8s_cluster.yml"
                echo "K8s minikube cluster configured succesfully!"
            }
        }
        stage("Configure Monitoring Tool"){
            steps{
                sh "ansible-playbook prometheus-grafana.yml"
                echo "Monitoring tool configured succesfully!"
            }
        }
        stage("Deploy the Webserver"){
            steps{
                sh "ansible-playbook deployDeployment.yml"
                sh "chmod +x startservers.sh"
                sh "./startservers.sh"
            }
        }
    }
}
