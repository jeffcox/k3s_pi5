# k3s_pi5

Run k3s on a pi5, as long as it has 8gb of RAM.


## Requirements

This is a snapshot of a personal project, in order to use it you'll need:

1. A Raspberry Pi 5 with 8GB of RAM.  You can run less services with less RAM, but that's no fun.
2. SSH access and sudo.  I used the Raspberry Pi imager and Ubuntu 24.04 with an SSH key set.
3. To make some manual edits (described below) to the files in this repository
4. An address range (currently just 1 IP) reserved for MetalLB
5. The ability to set DNS records locally (I use Pi Hole)
6. A CloudFlare account and a domain configured to use their resolver
7. An API token from CloudFlare, as [described in cert-manager documentation](https://cert-manager.io/docs/configuration/acme/dns01/cloudflare/#api-tokens)

## BEFORE YOU RUN ANYTHING

The enclosed playbook (k3s_pi.yml) will overwrite your `~/.kube/config file`, see line 61.

Most of these files are relatively small and you should read both the playbook and shell script
before you run them!

## Manual edits

1. Set vars in the k3s_pi.yml ansible playbook
2. Update netplan template file `k3s_pi_netplan.j2`
3. Update the following in `manifests/`:
    * awx.yaml - `spec.admin_user`, `spec.ingress_hosts.0.hostname`
    * gitea-values.yaml `gitea.server.domain`
    * jenkins-values.yaml `controller.ingress.hostName`
    * keycloak.yaml in the deployment, a container ENV named "KC_HOSTNAME"
    * keycloak.yaml, in the ingress `spec.tls.0.hosts.0`
    * metallb-ippool.yaml to match your network
    * production-issuer.yaml with your email
    * staging-issuer.yaml with your email
4. Update everything in `secrets/`

## Deployment

1. Create a venv:
    `python3 -m venv .venv`
2. Activate venv and install requirements:
	`source .venv/bin/activate && pip3 install -r requirements.txt`
3. Run the playbook
    `ansible-playbook k3s_pi.yml`
4. Run the boot-strap.zsh script
    `./boot-strap.zsh`

## Future plans

* Convert boot-strap.zsh into ansible
* Automate secret generation and store it in Keychain

## Why are you doing this/what's the point?

This is a home lab, it's for developing skills and testing ideas.

Currently, I host a small IAC repository to manage my local network, NAS, and other
services like HomeBridge, and general self hosting.
