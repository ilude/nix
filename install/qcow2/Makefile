# Check if .env file exists and if so, load the values
ifneq ("$(wildcard .env)","")
    include .env
endif

# Default values
UPLOAD_HOST ?= root@192.168.16.16

UPLOAD_FILES := outputs/nixos.qcow2 scripts/create-vm.sh
UPLOAD_MARKERS := $(addsuffix .uploaded,$(UPLOAD_FILES))

.PHONY: build upload clean echo
upload: $(UPLOAD_MARKERS) build

build: $(UPLOAD_FILES)

%.uploaded: %
	@echo "Uploading $< to $(UPLOAD_HOST):$(UPLOAD_DIR)/$(notdir $<)"
	@scp "$<" "$(UPLOAD_HOST):/tmp/$(notdir $<)"
	@touch "$@"

outputs/nixos.qcow2: .secrets build-qcow2.nix machine-config.nix | outputs
	@scripts/build-qcow2.sh $@

.secrets: scripts/create-secrets.sh
	@scripts/create-secrets.sh

outputs:
	@mkdir -p $@

clean:
	@rm -rf outputs/nixos.qcow2 $(UPLOAD_MARKERS)

echo:
	@echo "UPLOAD_FILES: $(UPLOAD_FILES)"
	@echo "UPLOAD_MARKERS: $(UPLOAD_MARKERS)"
