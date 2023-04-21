pipeline {

    agent any

    environment {
        ACCESS_TOKEN = credentials('GH_ACCESS_TOKEN')
    }

    parameters {
        string(name: 'DOCKERTAG', description: 'K8s manifest version number to point to.')
    }

    stages {
        stage("Update Deployment Manifest Image Version Number") {
            steps {
                sh "./deploy.sh ${ACCESS_TOKEN} ${DOCKERTAG}"
            }
        }
    }
}
