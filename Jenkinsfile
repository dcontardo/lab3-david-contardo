pipeline {
    agent {
        kubernetes {
            cloud 'kubernetes-lab3'
            yamlFile 'agent.yaml'
            defaultContainer 'node'
        }
    }

    stages {
        stage('install') {
            steps {
                container('node') {
                    sh 'corepack enable'
                    sh 'corepack prepare pnpm@12.3.4 --activate'
                    sh 'pnpm install --frozen-lockfile'
                }
            }
        }

        stage('test') {
            steps {
                container('node') {
                    sh 'pnpm test'
                }
            }
        }

        stage('build') {
            steps {
                container('kaniko') {
                    sh '''
                        /kaniko/executor \
                          --context "${WORKSPACE}" \
                          --dockerfile "${WORKSPACE}/Dockerfile" \
                          --destination "dcontardo/lab3:david-contardo" \
                          --no-push \
                          --tar-path "${WORKSPACE}/lab3.tar"
                    '''
                }
            }
        }

        stage('push') {
            steps {
                container('skopeo') {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'dockerhub-lab3',
                            usernameVariable: 'DOCKER_USER',
                            passwordVariable: 'DOCKER_PASSWORD'
                        ),
                        usernamePassword(
                            credentialsId: 'ghcr-lab3',
                            usernameVariable: 'GHCR_USER',
                            passwordVariable: 'GHCR_PASSWORD'
                        )
                    ]) {
                        sh '''
                            mkdir -p /tmp/skopeo

                            printf '%s' "$DOCKER_PASSWORD" | skopeo login docker.io \
                              --username "$DOCKER_USER" \
                              --password-stdin

                            printf '%s' "$GHCR_PASSWORD" | skopeo login ghcr.io \
                              --username "$GHCR_USER" \
                              --password-stdin

                            skopeo copy \
                              docker-archive:${WORKSPACE}/lab3.tar \
                              docker://dcontardo/lab3:david-contardo

                            skopeo copy \
                              docker-archive:${WORKSPACE}/lab3.tar \
                              docker://ghcr.io/dcontardo/lab3:david-contardo
                        '''
                    }
                }
            }
        }

        stage('deploy') {
            steps {
                container('kubectl') {
                    sh '''
                        sed '1,/^---$/d' ${WORKSPACE}/entrega.yaml > ${WORKSPACE}/deploy.yaml
                        kubectl apply -f ${WORKSPACE}/deploy.yaml
                        kubectl rollout status deployment/app-david-contardo \
                          -n ns-david-contardo \
                          --timeout=120s
                    '''
                }
            }
        }
    }
}
