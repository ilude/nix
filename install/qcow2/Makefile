.PHONY: copy-img 

outputs/.lastuploaded: outputs/nixos-compressed.qcow2
	scp outputs/nixos-compressed.qcow2 root@192.168.16.16:/tmp/nixos-$(shell date +%y%m%d-%H%M).img
	scp scripts/create-vm.sh root@192.168.16.16:/tmp
	touch $@

outputs/nixos-compressed.qcow2: outputs/.lastbuild 
	qemu-img convert -c -O qcow result/nixos.qcow2 outputs/nixos-compressed.qcow2

outputs/.lastbuild: .secrets build-qcow2.nix machine-config.nix | outputs 
	nix-build '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ ./build-qcow2.nix ]; }"
	touch $@

outputs:
	mkdir -p $@

clean:
	rm .secrets
	rm outputs/*

.secrets:
	@if [ ! -f ".secrets" ]; then \
		read -p "Enter your desired username: " -r username; \
		while true; do \
			read -s -p "Enter your password: " -r password; \secrets
			read -s -p "Confirm your password: " -r password_confirm; \secrets
			if [ "$$password" = "$$password_confirm" ]; then \
				break; \
			else \
				echo "Passwords do not match. Please try again."; \
			fi; \
		done; \
		hashed_password=$$(mkpasswd "$$password"); \
		while true; do \
			read -s -p "Enter your root password: " -r root_password; \
			read -s -p "Confirm your root password: " -r root_password_confirm; \secrets
			if [ "$$root_password" = "$$root_password_confirm" ]; then \
				break; \
			else \
				echo "Passwords do not match. Please try again."; \
			fi; \
		done; \
		hashed_root_password=$$(mkpasswd "$$root_password"); \
		echo "{ \
			user = { \
				username = \"$$username\"; \
				password = \"$$hashed_password\"; \
			}; \
			root = { \
				password = \"$$hashed_root_password\"; \
			}; \
		}" > .secrets; \
	fi
	nixfmt .secrets
