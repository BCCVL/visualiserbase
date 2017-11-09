node('docker') {

    def imagename
    def img

    def pip_pre = "True"
    def pypi_credentials = 'pypi_index_url_dev'
    if (params.stage == 'prod') {
        pip_pre = "False"
    }

    def PYPI_INDEX_CRED = 'pypi_index_url_dev'
    if (params.stage == 'rc' || params.stage == 'prod') {
        // no dev pre releases for rc and prod
        PYPI_INDEX_CRED = 'pypi_index_url_prod'
    }

    // fetch source
    stage('Checkout') {

        checkout scm

    }

    // build image
    stage('Build') {

        withCredentials([string(credentialsId: PYPI_INDEX_CRED, variable: 'PYPI_INDEX_URL')]) {
            docker.withRegistry('https://hub.bccvl.org.au', 'hub.bccvl.org.au') {
                imagename = "hub.bccvl.org.au/bccvl/visualiserbase:${dateTag()}"
                img = docker.build(imagename, "--pull --no-cache --build-arg PIP_INDEX_URL=${PYPI_INDEX_URL} --build-arg PIP_PRE=${pip_pre} .")
            }
        }

    }

    // publish image to registry
    stage('Publish') {

        docker.withRegistry('https://hub.bccvl.org.au', 'hub.bccvl.org.au') {
            img.push()
        }

        slackSend color: 'good', message: "New Image ${imagename}\n${env.JOB_URL}"

    }
}
