node('docker') {

  def imagename
  def img

  // fetch source
  stage('Checkout') {

    checkout scm

  }

  // build image
  stage('Build') {

    imagename = "hub.bccvl.org.au/bccvl/visualiserbase:${dateTag()}"
    img = docker.build(imagename, '--pull --no-cache .')

  }

  // publish image to registry
  stage('Publish') {

    img.push()

    slackSend color: 'good', message: "New Image ${imagename}\n${env.JOB_URL}"

  }
}
