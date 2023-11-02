#!/bin/bash

set -e

MAX_AGE=14  # Max age in days

DISTRO=ubuntu
VERSION="${VERSION:-22.04}"
ARCH="${ARCH:-amd64}"
ISO_DIR="/mnt/storage/disks/livemedia"
export ISO_URL="$(find "${ISO_DIR}" -name "${DISTRO}-${VERSION}*-live-server-${ARCH}.iso" | sort | tail -n 1)"
# Because the ISO is downloaded via bittorrent it's been verified as correctly
#   downloaded and it's safe to trust the checksum calculated below.
export ISO_CHECKSUM="$(sha256sum "${ISO_URL}" | cut -d ' ' -f 1)"
DEST_DIR=/mnt/storage/disks/images/${DISTRO}-${VERSION}
DEST_IMG="${DEST_DIR}/${DISTRO}-${VERSION}-${ARCH}-base-$(date +%Y-%m-%d-%H%M).qcow2"
export IMAGE_NAME="${DISTRO}-${VERSION}-${ARCH}"
export BUILD_DIR=builds
export ANSIBLE_VAULT_PASSWORD="$(cat secrets/ansible-vault-password)"

pushd "$(dirname "$0")" > /dev/null
# Cleanup from the last build
rm -rf "${BUILD_DIR}"
# Build the new image
packer build ${DISTRO}-${VERSION}-${ARCH}-base.pkr.hcl
# Ensure the destination exists
mkdir -p "${DEST_DIR}"
# Prune old images
find "${DEST_DIR}" -mindepth 1 -mtime +$MAX_AGE -delete
# Move the new image to the destination
mv "${BUILD_DIR}/${IMAGE_NAME}" "${DEST_IMG}"
# Link the new image to the static path
ln -sf "${DEST_IMG}" "${DEST_DIR}/${DISTRO}-${VERSION}-${ARCH}-base.qcow2"
popd > /dev/null
