# TODOs
1. Add Azure Cloud Controller
2. Add ingress controller
3. Deploy postgres
4. Deploy library app or whatever
5. Evaluate CRI-O vs Containerd for CRI implementation
6. Ensure Sysctl configuration setting is persisted to work across restarts
7. Figure out how to more sensibly structure the Ansible playbooks
8. Add worker nodes
9. Add monitoring
10. Maybe use ArgoCD Core instead of full fledged ArgoCD
11. Move files to host system and inject into Ansible Playbooks
12. Even better! Use Jinja2 templates to generate the files on the fly
13. Also, maybe use the "uses: ansible/ansible-playbook-action@v2.0.0" back in the GitHub Actions


# Bigger TODOS
1. Add a EC2 version of the terraform
2. Add a AKS terraform version
3. Explore whether or not it is possible to create a tiny bootstrap terraform
