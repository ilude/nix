#!/usr/bin/env bash

set -ex

if [ $# -ne 1 ]; then
    echo "Usage: $0 <output_path>"
    exit 1
fi

OUTPUT_PATH=$1

echo "Building ${OUTPUT_PATH}..."
IMAGE_FILE=$(nix-build --no-out-link '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ ./build-qcow2.nix ]; }")
cp -f "${IMAGE_FILE}/nixos.qcow2" "$OUTPUT_PATH"
