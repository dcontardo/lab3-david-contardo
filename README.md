# Laboratorio 3 - CI/CD en Kubernetes

## Datos

- Estudiante: David Contardo
- Namespace: ns-david-contardo
- Aplicación: app-david-contardo
- Service: svc-david-contardo
- ConfigMap: config-david-contardo
- Secret: secret-david-contardo

## Descripción

Este laboratorio implementa un flujo CI/CD para desplegar una aplicación NestJS en un clúster Kubernetes local.

El proyecto utiliza Docker para construir la aplicación, Docker Hub y GitHub Container Registry para publicar la imagen y Jenkins para automatizar el proceso de instalación, pruebas, construcción, publicación y despliegue.

## Tecnologías utilizadas

- Node.js 24
- NestJS
- pnpm
- Docker
- Kubernetes
- Jenkins
- Kaniko
- Skopeo
- Docker Hub
- GitHub Container Registry

## Imagen de la aplicación

Docker Hub:

dcontardo/lab3:david-contardo

GitHub Container Registry:

ghcr.io/dcontardo/lab3:david-contardo

## Kubernetes

La aplicación se despliega en el namespace ns-david-contardo.

El Deployment utiliza 2 réplicas y obtiene las variables de configuración desde un ConfigMap y un Secret.

### ConfigMap

Variable utilizada: AMBIENTE=produccion

### Secret

Variable utilizada: API_KEY

La aplicación utiliza estas variables mediante el endpoint /lab.

## Pipeline Jenkins

El pipeline está compuesto por las siguientes etapas:

1. install - Instala las dependencias del proyecto.
2. test - Ejecuta las pruebas automatizadas.
3. build - Construye la imagen mediante Kaniko.
4. push - Publica la imagen en Docker Hub y GitHub Container Registry.
5. deploy - Despliega la aplicación en Kubernetes.

Jenkins utiliza agentes dinámicos de Kubernetes definidos en agent.yaml.

Las credenciales utilizadas para publicar las imágenes se administran mediante credenciales de Jenkins y no están escritas directamente en el Jenkinsfile.

## Ejecución manual

Instalar dependencias:

    pnpm install --frozen-lockfile

Ejecutar pruebas:

    pnpm test

Construir la imagen:

    docker build -t dcontardo/lab3:david-contardo .

Aplicar los recursos de Kubernetes:

    kubectl apply -f entrega.yaml

Verificar el despliegue:

    kubectl get pods -n ns-david-contardo
    kubectl get deployment -n ns-david-contardo
    kubectl get svc -n ns-david-contardo

Probar la aplicación:

    kubectl port-forward svc/svc-david-contardo 8080:80 -n ns-david-contardo

En otra terminal:

    curl http://localhost:8080/lab

Respuesta esperada:

    {"AMBIENTE":"produccion","API_KEY":"lab3-david-contardo-key"}

## Evidencias

La carpeta evidencias/ contiene las salidas de comandos y evidencias solicitadas para demostrar:

- Estado del clúster Kubernetes.
- Estado de los nodos.
- Pods y Deployment.
- Service.
- Logs de la aplicación.
- Variables de entorno.
- ConfigMap y Secret.
- Prueba mediante port-forward y curl.
- Ejecución exitosa del pipeline Jenkins.
