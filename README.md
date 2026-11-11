# AlmaLinux 10 cloud images

Cloud-init-ready, signed AlmaLinux 10 qcow2 images for OpenStack and Proxmox,
part of the [openimages.cloud](https://openimages.cloud) catalog.

- Catalog page: <https://openimages.cloud/images/almalinux-10/>
- Registry: <https://images.openimages.cloud/almalinux-10/latest/>

## About

AlmaLinux 10 is a community enterprise Linux, binary-compatible with RHEL 10, published by the AlmaLinux OS Foundation
([https://almalinux.org/](https://almalinux.org/)). This repo takes the official upstream
GenericCloud image ([listing](https://repo.almalinux.org/almalinux/10/cloud/x86_64/images/)), verifies it against the
upstream checksum list, applies the openimages.cloud cloud-init policy,
boot-tests it, signs it with cosign (keyless) and publishes it.

The build pipeline is shared with the rest of
[`open-img-cloud`](https://github.com/open-img-cloud): this repo only ships
`VERSION`, `build/customize.sh`, `build/detect-upstream.sh` and two thin
caller workflows that delegate to the reusable workflows in
[`open-img-cloud/.github`](https://github.com/open-img-cloud/.github).

## Lifecycle

AlmaLinux 10 is supported until **2035**. Like RHEL 10 it requires an **x86-64-v3** CPU (Haswell or newer): make sure the hypervisor CPU model of your flavors exposes it.

## Image

- File: `almalinux-10-<version>-x86_64.qcow2`, where `<version>` is the upstream
  image version (e.g. `10.2-20261109.0`).
- Default user: `almalinux` (SSH key from cloud-init, passwordless sudo).
- Virtual disk: 10 GB; any flavor with a 10 GB+ root disk works.

## Use it

```sh
V=10.2-20261109.0
curl -fLO https://images.openimages.cloud/almalinux-10/$V/almalinux-10-$V-x86_64.qcow2

openstack image create \
    --disk-format qcow2 --container-format bare \
    --property hw_qemu_guest_agent=yes \
    --file almalinux-10-$V-x86_64.qcow2 \
    'AlmaLinux 10 '$V
```

Verification (cosign), Proxmox commands and provenance details are on the
[catalog page](https://openimages.cloud/images/almalinux-10/) and in the
[verification guide](https://openimages.cloud/verify/).

## Release flow

1. `watch.yml` runs daily (06:26 UTC) and opens an
   `auto/upstream-bump` pull request when upstream publishes a new image.
2. Merge it, then push the tag `v<VERSION>`: `release.yml` builds, boot-tests,
   signs and publishes the image.

## License

The build tooling in this repository is [GPL-2.0](LICENSE). The image keeps
the licensing terms of AlmaLinux 10.
