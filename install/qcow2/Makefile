.PHONY: copy-img 

outputs/.lastuploaded: outputs/nixos-compressed.qcow2
	scp outputs/nixos-compressed.qcow2 root@192.168.16.16:/tmp/nixos-$(shell date +%y%m%d-%H%M).img
	scp scripts/create-vm.sh root@192.168.16.16:/tmp
	touch $@

outputs/nixos-compressed.qcow2: outputs/.lastbuild 
	-qemu-img convert -p -O qcow result/nixos.qcow2 outputs/nixos-compressed.qcow2

outputs/.lastbuild: .secrets build-qcow2.nix machine-config.nix | outputs 
	nix-build '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ ./build-qcow2.nix ]; }"
	touch $@

outputs:
	mkdir -p $@

clean:
	rm .secrets
	rm outputs/*

.secrets:
	scripts/create-secrets.sh