ASSIGNMENT 2 VERIFIED ADVANCED DEPLOYMENT FILES
Extract these files into the existing application repository root (beside docker-compose.yml).
The original application source and Dockerfiles remain required.

Added directories: k8s/ and monitoring/.
See k8s/README.txt for image loading, runtime Secret creation, deployment and browser access.
See monitoring/README.txt for Prometheus/Grafana startup and outage/recovery verification.
Runtime Secrets, kubeconfig and recorder dependencies are not included.

The online main branch was inspected on 3 November 2026 at commit
77e46364245ad25c20de1cf1fcfc4431fd639d4f. These advanced directories were absent.
Commit them BEFORE submission so the advanced deployment is reproducible from GitHub.
Add links to these two READMEs in your existing root README.md.

Git Bash from your EXISTING repository checkout:
git status --short
git add k8s monitoring README_ASSIGNMENT2_ADVANCED.txt README.md
git commit -m "Add verified Kubernetes deployment and Prometheus Grafana monitoring"
git push origin main

After uploading the reviewed MP4, check viewer access to the video/report/evidence
folders already linked in the final report. Convert the final DOCX to PDF yourself.
