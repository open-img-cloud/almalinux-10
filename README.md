<p align="center">
  <a href="https://openimages.cloud/images/almalinux-10/">
    <img src="https://openimages.cloud/img/og/almalinux-10.png" alt="AlmaLinux 10 cloud image for OpenStack and Proxmox" width="720">
  </a>
</p>

<p align="center">
  <a href="https://openimages.cloud/images/almalinux-10/"><img alt="Latest version" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fimages.openimages.cloud%2Falmalinux-10%2Flatest%2FMANIFEST.json&query=%24.version&label=latest&color=2459c4&cacheSeconds=3600"></a>
  <a href="https://github.com/open-img-cloud/almalinux-10/actions/workflows/release.yml"><img alt="Release" src="https://github.com/open-img-cloud/almalinux-10/actions/workflows/release.yml/badge.svg"></a>
  <a href="https://openimages.cloud/verify/"><img alt="Signed with Sigstore cosign" src="https://img.shields.io/badge/signed-Sigstore%20cosign-2459c4"></a>
  <a href="https://openimages.cloud/quality/"><img alt="Boot-tested on OpenStack" src="https://img.shields.io/badge/boot--tested-OpenStack-2459c4"></a>
  <a href="LICENSE"><img alt="License GPL-2.0" src="https://img.shields.io/badge/license-GPL--2.0-555"></a>
</p>

<p align="center">
  <a href="https://openimages.cloud/images/almalinux-10/"><b>Catalog page</b></a> ·
  <a href="https://images.openimages.cloud/almalinux-10/latest/">Download</a> ·
  <a href="https://openimages.cloud/verify/">Verify</a> ·
  <a href="https://github.com/open-img-cloud/docs">Documentation</a> ·
  <a href="https://github.com/open-img-cloud/almalinux-10/issues">Report an issue</a>
</p>

AlmaLinux 10 cloud image (qcow2) for **OpenStack** and **Proxmox**: the official AlmaLinux
GenericCloud image, binary-compatible with RHEL 10, verified, made ready for both clouds with the same rules
as every [openimages.cloud](https://openimages.cloud) image, signed with Sigstore cosign and
boot-tested on a real OpenStack before it is published.

## At a glance

| | |
|---|---|
| **Upstream** | [AlmaLinux](https://almalinux.org/) GenericCloud image from [the official mirror](https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/), checked against its `CHECKSUM` list |
| **Default user** | `almalinux`, SSH key only, passwordless `sudo` |
| **Firmware** | BIOS |
| **Format** | qcow2, x86_64, 10 GB virtual disk, root filesystem grown to the disk at first boot |
| **Version** | `10.<minor>-<build date>.<n>`, the upstream image version, e.g. `10.2-20261109.0` ([all versions](https://images.openimages.cloud/almalinux-10/versions.json)) |
| **CPU** | x86-64-v3 (Haswell or newer), like RHEL 10: the hypervisor CPU model must expose it |
| **Support** | Supported until 2035 |

## Quick start

```sh
# Latest version and its file name, from the signed manifest
M=https://images.openimages.cloud/almalinux-10/latest/MANIFEST.json
V=$(curl -fsS $M | jq -r .version); F=$(curl -fsS $M | jq -r .filename)
curl -fLO https://images.openimages.cloud/almalinux-10/$V/$F
```

<details>
<summary><b>OpenStack</b></summary>

```sh
openstack image create --disk-format qcow2 --container-format bare \
  --property os_distro=almalinux --property os_version="${V%%-*}" \
  --property hw_qemu_guest_agent=yes --property os_admin_user=almalinux \
  --file "$F" "AlmaLinux 10"
```

The full property set (SCSI disk, multiqueue, quiesced snapshots) is on the
[catalog page](https://openimages.cloud/images/almalinux-10/) and in
[`index.json`](https://images.openimages.cloud/index.json). To keep images up to date
automatically, use [oic-sync](https://github.com/open-img-cloud/oic-sync).

</details>

<details>
<summary><b>Proxmox VE</b></summary>

The commands to create a cloud-init template from this image are on the
[catalog page](https://openimages.cloud/images/almalinux-10/).

</details>

<details>
<summary><b>Verify the signature</b></summary>

```sh
curl -fLO https://images.openimages.cloud/almalinux-10/$V/$F.bundle
cosign verify-blob "$F" --bundle "$F.bundle" \
  --certificate-identity-regexp '^https://github.com/open-img-cloud/\.github/\.github/workflows/build-(libguestfs|dib|nix-flake|freebsd)-image\.yml@' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com
```

</details>

## What this image changes

The upstream image already ships cloud-init, `qemu-guest-agent` and a serial console. On top of it, and nothing else:

- adds the openimages.cloud cloud-init policy: config drive read first, then the metadata
  service; no root login, no SSH password;
- cleans package caches and machine identity so every instance starts fresh.

Every release must pass the same [runtime contract](https://openimages.cloud/quality/) on
OpenStack: SSH with the injected key, cloud-init finished, DNS, hostname, root filesystem grown,
passwordless `sudo`, IPv6 address and egress.

## How releases happen

1. Every day at 06:26 UTC a watcher looks for a new upstream image and opens a pull request
   that bumps [`VERSION`](VERSION).
2. Merging it is all it takes: the release is tagged, built, signed, boot-tested and
   published, then `latest/` and the [catalog](https://openimages.cloud/images/) move to it.

This repository only holds what is specific to AlmaLinux 10: [`VERSION`](VERSION),
[`build/customize.sh`](build/customize.sh), [`build/detect-upstream.sh`](build/detect-upstream.sh)
and thin workflows calling the shared pipeline in
[`open-img-cloud/.github`](https://github.com/open-img-cloud/.github).

## License

The build tooling in this repository is under [GPL-2.0](LICENSE). The image keeps the licensing
terms of AlmaLinux (free software under the license of each package). AlmaLinux is
published by the AlmaLinux OS Foundation; this project is not affiliated with it.
