pipeline {
    agent any

    tools {
        go 'go_1.20.6'
    }
    
    environment {
        GOPROXY = 'https://goproxy.cn,direct'
    }

    stages {
        stage('Build') {
            steps {
                sh 'rm -rf .target' //清理旧打包
                sh 'go build -o .target/hellogo-${GIT_COMMIT} main.go' //打包
                archiveArtifacts artifacts: ".target/hellogo-${GIT_COMMIT}", fingerprint: true //加入本地制品库
            }
        }
        stage('Deploy with Ansible') {
            steps {
                withCredentials([
                    sshUserPrivateKey(credentialsId: '54e6cd1d-d917-4427-ac13-6d7ff0abdc39', keyFileVariable: 'SSH_KEY'),
                    string(credentialsId: '563e5a99-0d79-4b2d-a2e8-0061db54fbf5', variable: 'ANSIBLE_BECOME_PASS')
                ]) {
                    sh '''
                        ansible-playbook \
                        -u guobin \
                        -e "ansible_ssh_private_key_file=${SSH_KEY}" \
                        -e "build_dir=../../hellogo" \
                        -e "artifact=../.target/hellogo-${GIT_COMMIT}" \
                        -e "ansible_become_password=${ANSIBLE_BECOME_PASS}" \
                        -i ansible/inventory.ini \
                        ansible/deploy.yml
                    '''
                }
            }
        }
    }
}
