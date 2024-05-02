# Check if .env file exists and if so, load the values
ifneq ("$(wildcard .env)","")
    include .env
endif

# Default values
UPLOAD_HOST ?= root@192.168.16.16

UPLOAD_FILES := outputs/nixos.qcow2 scripts/create-vm.sh
UPLOAD_MARKERS := $(addsuffix .uploaded,$(UPLOAD_FILES))
PREREQS := $(UPLOAD_FILES) $(UPLOAD_MARKERS)

.PHONY: upload clean echo
upload: $(PREREQS)

%.uploaded: %
	@echo "Uploading $< to $(UPLOAD_HOST):$(UPLOAD_DIR)/$(notdir $<)"
	@scp "$<" "$(UPLOAD_HOST):/tmp/$(notdir $<)"
	@touch "$@"

clean:
	rm -rf outputs/nixos.qcow2 $(UPLOAD_MARKERS)

outputs/nixos.qcow2: .secrets build-qcow2.nix machine-config.nix | outputs
	@echo "Building $@"
	@nix-build '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ ./build-qcow2.nix ]; }"
	@cp result/nixos.qcow2 $@

outputs:
	@mkdir -p $@

echo:
	@echo "prereqs: $(PREREQS)"
