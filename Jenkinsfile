node("master") {

  docker.image('lasote/conangcc63').inside {

    stage('Build Settings') {
	echo "\u2600 JOB=${env.JOB_NAME}"
	echo "\u2600 BUILD_NUMBER=${env.BUILD_NUMBER}"
        echo "\u2600 BUILD_URL=${env.BUILD_URL}"
	echo "\u2600 workspace=${workspace}"
    }

    stage('Checkout project') {
        checkout scm
    }

    stage('Clone enet') {
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
