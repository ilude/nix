# Check if .env file exists and if so, load the values
ifneq ("$(wildcard .env)","")
		include .env
endif

# Default values
UPLOAD_HOST ?= root@192.168.16.16
CREATE_VM_SCRIPT ?= create-vm.sh
VM_ID ?= 8500
VM_STORAGE ?= local-lvm

# files to upload
UPLOAD_FILES := outputs/nixos.qcow2 scripts/$(CREATE_VM_SCRIPT)

# magic pixie dust to make the upload markers files
UPLOAD_MARKERS := $(addsuffix .uploaded,$(UPLOAD_FILES))

.PHONY: build upload clean echo

upload: $(UPLOAD_MARKERS) build
ifeq ($(filter it-live,$(MAKECMDGOALS)),)
		@echo "upload completed, if you want to run the image use:"
		@echo ""
		@echo "  make it-live"
		@echo ""
endif

build: $(UPLOAD_FILES)

it-live: upload
	@scripts/run-remote-script.sh $(UPLOAD_HOST) "/tmp/$(CREATE_VM_SCRIPT) $(VM_ID) $(VM_STORAGE)"

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
