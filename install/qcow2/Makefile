.PHONY: copy-img 

# BUILD_CONFIG := secrets-embedded-qcow2.nix
BUILD_CONFIG := build-qcow2.nix

outputs/.lastuploaded: outputs/.lastbuild scripts/create-vm.sh
	scp result/nixos.qcow2 root@192.168.16.16:/tmp/nixos-$(shell date +%y%m%d-%H%M).qcow2
	scp scripts/create-vm.sh root@192.168.16.16:/tmp
	touch $@

# outputs/nixos-compressed.qcow2: outputs/.lastbuild 
# 	-qemu-img convert -p -O qcow result/nixos.qcow2 outputs/nixos-compressed.qcow2

outputs/.lastbuild: .secrets $(BUILD_CONFIG) machine-config.nix | outputs 
	nix-build '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ ./$(BUILD_CONFIG) ]; }"
	touch $@

force:
	touch $(BUILD_CONFIG)
	$(MAKE)

outputs: 
	mkdir -p $@

clean:
	rm .secrets
	rm outputs/*

.secrets:
	scripts/create-secrets.sh
