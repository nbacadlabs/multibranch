//az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --overwrite-existing
pipeline {
    agent {
        kubernetes {
          yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: node
                image: node:16-alpine3.12
                command:
                - cat
                tty: true
            '''
        }
    }
    environment {
        RESOURCE_GROUP = "nbaksclust-rg"
        AKS_CLUSTER = "prod-aks"
        BRANCH_NAME = "main"
    }
    stages {
      stage('Setup and Install Azure CLI') {
        steps {
          container('node') {
            sh '''
              # Update package lists
              apk update
              # Install required dependencies
              apk add --no-cache curl bash jq sudo unzip py3-pip python3-dev gcc musl-dev libffi-dev openssl-dev cargo
              # Installation terraform
              TERRAFORM_VERSION=$(curl -sL https://api.github.com/repos/hashicorp/terraform/releases/latest | grep '"tag_name"' | cut -d '"' -f 4 | sed 's/v//')
              curl -fsSL -o terraform.zip "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
              unzip terraform.zip
              mv terraform /usr/local/bin/
              chmod +x /usr/local/bin/terraform
              terraform version
              # installation of kubectl
              curl -LO "https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl"
              chmod +x kubectl
              mv kubectl /usr/local/bin/
              kubectl version --client
              # Install Rust and Cargo
              curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
              
              # Ensure Cargo is in PATH
              export PATH="$HOME/.cargo/bin:$PATH"

              # Verify Rust and Cargo installation
              rustc --version
              cargo --version

              # Upgrade pip and install Azure CLI
              python3 -m pip install --upgrade pip setuptools wheel
              pip install azure-cli
            '''
            // Verify Azure CLI installation
            sh 'az version'
            script {
                    withCredentials([azureServicePrincipal('Azure_SP_ID')]) {
                        sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        az account show
                        '''
                    }
            }
          }
        }
      }
      stage('Azure Login') {
            steps {
              container('node') {
                // sh '''
                // # Update package lists
                // apk update
                
                // # Install required dependencies
                // apk add --no-cache curl bash jq sudo py3-pip python3-dev gcc musl-dev libffi-dev openssl-dev cargo

                // # Install Rust and Cargo
                // curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
                
                // # Ensure Cargo is in PATH
                // export PATH="$HOME/.cargo/bin:$PATH"

                // # Verify Rust and Cargo installation
                // rustc --version
                // cargo --version

                // # Upgrade pip and install Azure CLI
                // python3 -m pip install --upgrade pip setuptools wheel
                // pip install azure-cli
                // '''
                // Verify Azure CLI installation
                sh 'az version'
                script {
                    withCredentials([azureServicePrincipal('Azure_SP_ID')]) {
                        sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --overwrite-existing
                        kubectl apply -f clustermgmt/
                        kubectl get pods
                        '''
                    }
                }
            }
          }
       }
    }
}