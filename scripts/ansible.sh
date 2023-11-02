#!/bin/bash

set -ex

wget https://gitea.local/haxwithaxe/ansible-debian-base/raw/branch/main/pull.sh -O /tmp/ansible-setup.sh
set +x # Don't show the password in the logs
echo -n "$ANSIBLE_VAULT_PASSWORD" > /tmp/ansible-vault-password
echo -n "$ANSIBLE_VAULT_PASSWORD" | wc  # DEBUG
wc /tmp/ansible-vault-password
set -x
bash /tmp/ansible-setup.sh --purge --vault-password-file /tmp/ansible-vault-password 
rm -f /tmp/ansible-setup.sh /tmp/ansible-vault-password
