pipeline {
    agent none

    environment {
        SSH_KEY_PATH = '/var/lib/jenkins/.ssh/id_rsa_jenkins' // Path to SSH private key for VM2 access
    }

    stages {
        stage('Install Docker via Ansible on VM2') {
            agent { label 'VM1-Master' }
            steps {
                sh '''
                    ansible-playbook -i "20.121.117.104," /var/lib/jenkins/install_docker.yml \
                        --private-key "$SSH_KEY_PATH" -u azureuser
                '''
            }
        }

        stage('Pull, Build, and Deploy PHP Docker Application') {
            agent { label 'VM1-Master' }
            steps {
                sh '''
                    ssh -v -i /var/lib/jenkins/.ssh/id_rsa_jenkins azureuser@20.121.117.104 '
                    rm -rf app || true &&
                    git clone https://github.com/sreeni85/projCert.git app &&
                    cd app &&
                    docker build -t my-php-app . &&
                    docker stop my-php-app || true &&
                    docker rm my-php-app || true &&
                    docker run -d --name my-php-app -p 80:80 my-php-app
                    '
                '''
            }
        }
    }

    post {
        failure {
            script {
                sh '''
                    ssh -i "$SSH_KEY_PATH" azureuser@20.121.117.104 'docker rm -f my-php-app || true'
                '''
            }
        }
    }
}
  
