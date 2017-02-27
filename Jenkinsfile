node('docker') {

    def imagename
    def img

    def pip_pre = "True"
    if (params.stage == 'rc' || params.stage == 'prod') {
        pip_pre = "False"
    }

    def INDEX_HOST = env.PIP_INDEX_HOST
    def INDEX_URL = "http://${INDEX_HOST}:3141/bccvl/prod/+simple/"

    // fetch source
    stage('Checkout') {

        checkout scm

    }

    // build image
    stage('Build') {

        imagename = "hub.bccvl.org.au/bccvl/visualiserbase:${dateTag()}"
        img = docker.build(imagename, "--pull --no-cache --build-arg PIP_INDEX_URL=${INDEX_URL} --build-arg PIP_TRUSTED_HOST=${INDEX_HOST} --build-arg PIP_PRE=${pip_pre} .")

    }

    // publish image to registry
    stage('Publish') {

        img.push()

        slackSend color: 'good', message: "New Image ${imagename}\n${env.JOB_URL}"

    }
}
