//az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --overwrite-existing. test
pipeline {
    agent {
        kubernetes {
          yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: podtemplate
                image: vakem/kubepodtemplate
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
      stage('SonarQube Analysis') {
        steps {
              withSonarQubeEnv(installationName: 'SonarScanner') {
                // sh "${mvn}/bin/mvn clean verify sonar:sonar -Dsonar.projectKey=sonatest1 -Dsonar.projectName='sonatest1'"
                sh './mvnw clean org.sonarsource.scanner.maven:sonar-maven-plugin:3.9.0.2155:sonar'
            }
          }
        }
      }
      stage('Setup and Install Azure CLI') {
        steps {
          container('podtemplate') {
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
              container('podtemplate') {
                sh 'az version'
                script {
                    withCredentials([azureServicePrincipal('Azure_SP_ID')]) {
                        sh '''
                        az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_CLIENT_SECRET --tenant $AZURE_TENANT_ID
                        az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_CLUSTER --overwrite-existing
                        kubectl get pods
                        '''
                    }
                }
            }
          }
       }
    }


//  kubectl apply -f 02-clustermgmt/ #