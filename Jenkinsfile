pipeline {
    agent any
    environment {
        MVN_HOME = "/usr/local/lib/apache-maven-3.6.0"
    }
    stages {
        stage('Checkout') {
            steps {
              checkout scm
            }
        }
        stage('Build') {
            steps {
                sh "${MVN_HOME}/bin/mvn clean install -B -U"
            }
        }
        stage('Test') {
            steps {
                sh "${MVN_HOME}/bin/mvn verify"
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        stage('Scan') {
            steps {
                sh "${MVN_HOME}/bin/mvn cobertura:cobertura -Dcobertura.report.format=xml"
                cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: ' **/target/site/cobertura/coverage.xml', conditionalCoverageTargets: '70, 0, 0', failUnhealthy: false, failUnstable: false, lineCoverageTargets: '80, 0, 0', maxNumberOfBuilds: 0, methodCoverageTargets: '80, 0, 0', onlyStable: false, sourceEncoding: 'ASCII', zoomCoverageChart: false
            }
        }
        stage('Deploy'){
            steps {
                script{
                    def dockerImage = docker.build("game-of-life-image", "./gameoflife-web")
                    try {
                        sh """
                            docker stop game-of-life-web
                            docker rm -f game-of-life-web
                           """
                    }
                    catch (Exception e) { echo "container is not running" }
                    dockerImage.run("-p 9090:8080 --name game-of-life-web")
                }
            }
        }
        stage('UAT') {
            steps {
              sh 'cd tests && cucumber APP_URL=http://localhost:9090'
              cucumber fileIncludePattern: '**/*.json', sortingMethod: 'ALPHABETICAL'
            }
        }
    }
}
