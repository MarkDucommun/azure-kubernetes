# TODOs
1. [ ] Add Azure Cloud Controller
1. [ ] Add ingress controller
1. [ ] Deploy postgres
1. [ ] Deploy library app or whatever
1. [ ] Evaluate CRI-O vs Containerd for CRI implementation
1. [ ] Ensure Sysctl configuration setting is persisted to work across restarts
1. [ ] Figure out how to more sensibly structure the Ansible playbooks
1. [ ] Add worker nodes
1. [ ] Add monitoring
1. [ ] Maybe use ArgoCD Core instead of full fledged ArgoCD
1. [ ] Move files to host system and inject into Ansible Playbooks
1. [ ] Even better! Use Jinja2 templates to generate the files on the fly
1. [ ] Also, maybe use the "uses: ansible/ansible-playbook-action@v2.0.0" back in the GitHub Actions


# Bigger TODOS
1. [ ] Add a EC2 version of the terraform
1. [ ] Add a AKS terraform version
1. [ ] Explore whether or not it is possible to create a tiny bootstrap terraform
