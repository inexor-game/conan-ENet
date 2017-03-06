node("master") {

  stage("Cleanup") {
    deleteDir()
  }

  stage('Build Settings') {
    echo "\u2600 JOB=${env.JOB_NAME}"
    echo "\u2600 BUILD_NUMBER=${env.BUILD_NUMBER}"
    echo "\u2600 BUILD_URL=${env.BUILD_URL}"
    echo "\u2600 workspace=${workspace}"
  }

  stage('Checkout project') {
    checkout scm
  }

  stage('docker') {
    def environment  = docker.build('inexor-game/conangcc63')
    environment.inside('--memory-swap=-1') {

      stage('Fetching enet sources') {
        sh 'conan source'
      }

      stage('Install and build dependencies') {
        dir('build') {
          sh 'conan install .. --build=missing'
        }
      }

      stage('Build with conan') {
        dir('build') {
          withEnv(['MAKEFLAGS="-j 2"']) {
            sh 'conan build ..'
          }
        }
      }

    }
  }

  stage("Cleanup") {
    deleteDir()
  }

}
