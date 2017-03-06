node { 

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
