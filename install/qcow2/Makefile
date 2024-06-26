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

# Check if 'force' is in MAKECMDGOALS and set the FORCE_FLAG accordingly
ifeq ($(filter force,$(MAKECMDGOALS)),force)
FORCE_FLAG := -y
else
FORCE_FLAG :=
endif

.PHONY: build upload clean echo default completion

default: upload

upload: $(UPLOAD_MARKERS)

build: $(UPLOAD_FILES)
ifeq ($(filter it-live,$(MAKECMDGOALS)),)
		@echo "upload completed, if you want to run the image use:"
		@echo ""
		@echo " make it-live"
		@echo ""
endif

it-live: upload
		@scripts/run-remote-script.sh $(FORCE_FLAG) $(UPLOAD_HOST) "/tmp/$(CREATE_VM_SCRIPT) $(VM_ID) $(VM_STORAGE)"

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

# Print message at the end of the run
completion:
		@echo "make $(or $(MAKECMDGOALS),default) completed at: $(shell date +"%Y-%m-%d %H:%M:%S")"

$(or $(MAKECMDGOALS),default): completion