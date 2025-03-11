pipeline {
    agent {
        kubernetes {
            yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: azure-cli
                image: mcr.microsoft.com/azure-cli:2.26.0
                command:
                - cat
                tty: true
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
        stage('Setup Azure CLI and Tools') {
            steps {
                container('azure-cli') {
                    // Log in to Azure using Service Principal
                    script {
                        withCredentials([azureServicePrincipal('AZURE_SP_ID')]) {
                            sh '''
                            az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                            az account show
                            az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --overwrite-existing
                            kubectl get pods
                            '''
                        }
                    }
                }
            }
        }
        stage('Azure and Kubernetes Setup') {
            steps {
                container('node') {
                    sh '''
                    # Use kubectl to interact with the AKS cluster
                    kubectl get pods
                    '''
                }
            }
        }
    }
}
