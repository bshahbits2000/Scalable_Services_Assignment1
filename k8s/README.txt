SEATFLOW KUBERNETES DEPLOYMENT CONFIGURATION
The recorder generates per-run manifests from the same six-service template in
app-template.json and creates a private runtime Secret. No real credentials are
included here. PostgreSQL initializes distinct role-owned service databases.
The entire PostgreSQL init directory is replaced by a ConfigMap to avoid using
the original demo-password SQL. PostgreSQL uses a 1Gi persistent volume claim.
Application Deployments have startup/readiness probes and use Service DNS.
imagePullPolicy Never requires the local images to be loaded before deployment.

MANUAL FIRST DEPLOYMENT (PowerShell from the application repository root)
Prerequisites: Docker Desktop, Minikube, working application Dockerfiles.
Use a fresh local demonstration namespace. Preserve Secret/database password pairs
on subsequent runs; do not regenerate a Secret against an existing initialized PVC.

docker compose up -d --build
minikube start -p seatflow-assignment2 --driver=docker --cpus=2 --memory=4096 --keep-context
foreach ($sfService in @('postgres','inventory','payment','notification','booking','ui')) {
  $sfContainer = docker compose ps -q $sfService
  $sfImage = docker inspect --format '{{.Config.Image}}' $sfContainer
  docker tag $sfImage "seatflow-a2-${sfService}:local"
  minikube -p seatflow-assignment2 image load --daemon "seatflow-a2-${sfService}:local"
}
minikube -p seatflow-assignment2 kubectl -- --context seatflow-assignment2 create namespace seatflow-a2-demo
$sfData = @{'postgres-password'=[guid]::NewGuid().ToString('N')}
foreach ($sfService in @('booking','inventory','payment','notification')) {
  $sfData["$sfService-password"]=[guid]::NewGuid().ToString('N')
  $sfData["$sfService-url"]="postgresql://sf_${sfService}:$($sfData["$sfService-password"])@postgres:5432/sf_${sfService}"
}
@{apiVersion='v1';kind='Secret';metadata=@{name='seatflow-db';namespace='seatflow-a2-demo'};type='Opaque';stringData=$sfData} | ConvertTo-Json -Depth 6 | minikube -p seatflow-assignment2 kubectl -- --context seatflow-assignment2 -n seatflow-a2-demo create -f -
minikube -p seatflow-assignment2 kubectl -- --context seatflow-assignment2 -n seatflow-a2-demo apply -f k8s/app-template.json
foreach ($sfService in @('postgres','inventory','payment','notification','booking','ui')) {
  minikube -p seatflow-assignment2 kubectl -- --context seatflow-assignment2 -n seatflow-a2-demo rollout status "deployment/$sfService" --timeout=240s
}
minikube -p seatflow-assignment2 kubectl -- --context seatflow-assignment2 -n seatflow-a2-demo get deployments,services,pods,pvc
minikube -p seatflow-assignment2 kubectl -- --context seatflow-assignment2 -n seatflow-a2-demo port-forward --address=127.0.0.1 service/ui 15173:5173

With the forwarder running, browse http://127.0.0.1:15173, create a workshop and
booking, then confirm the booking/payment/notification/reservation states via the
UI and /svc/<service>/api/v1/... endpoints on THIS Kubernetes-forwarded URL.
The automatic recorder performs these steps with unique per-run namespaces and
records all assertions, raw logs and screenshots. It also captures Compose and
observability in the same 6-8 minute narrated demonstration.

These are single-node coursework manifests, not a production HA deployment.
Do not publish Kubernetes Secret values, kubeconfig, private keys or runtime data.
Keep configuration and the matching evidence with the assignment repository.
Stop the local cluster after review: minikube -p seatflow-assignment2 stop

References
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
https://kubernetes.io/docs/concepts/services-networking/service/
https://minikube.sigs.k8s.io/docs/commands/image/
