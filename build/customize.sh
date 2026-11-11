#!/usr/bin/env bash
# Customize hook called by the build-libguestfs-image reusable workflow.
# Receives the qcow2 path as $1.
#
# The upstream AlmaLinux 10 GenericCloud image already ships cloud-init,
# openssh-server, qemu-guest-agent, a serial console and the `almalinux`
# default user. The org-wide cloud-init policy drop-in (datasource_list,
# disable_root, ssh_pwauth=false, mount_default_fields) is injected by the
# reusable workflow after this script runs. Customisation reduces to a
# package cache cleanup so the published qcow2 stays small.

set -euo pipefail

QCOW2="${1:?usage: customize.sh <path-to-qcow2>}"

if [[ ! -f "$QCOW2" ]]; then
  echo "::error::qcow2 not found: $QCOW2" >&2
  exit 1
fi

echo "[customize] target: $QCOW2"

virt-customize -a "$QCOW2" \
  --run-command 'rm -rf /var/cache/dnf /var/cache/yum /tmp/* /var/tmp/*'

echo "[customize] done"
