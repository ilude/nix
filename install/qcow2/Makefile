build: secrets.nix
	nix-build '<nixpkgs/nixos>' -A config.system.build.qcow2 --arg configuration "{ imports = [ ./build-qcow2.nix ]; }"

secrets.nix:
	@if [ ! -f "secrets.nix" ]; then \
		read -p "Enter your desired username: " -r username; \
		while true; do \
			read -p "Enter your password: " -r password; \
			read -p "Confirm your password: " -r password_confirm; \
			if [ "$$password" = "$$password_confirm" ]; then \
				break; \
			else \
				echo "Passwords do not match. Please try again."; \
			fi; \
		done; \
		hashed_password=$$(mkpasswd -m sha-512 "$$password"); \
		while true; do \
			read -p "Enter your root password: " -r root_password; \
			read -p "Confirm your root password: " -r root_password_confirm; \
			if [ "$$root_password" = "$$root_password_confirm" ]; then \
				break; \
			else \
				echo "Passwords do not match. Please try again."; \
			fi; \
		done; \
		hashed_root_password=$$(mkpasswd -m sha-512 "$$root_password"); \
		echo "{ \
			users = { \
				$$username = { \
					password = \"$$hashed_password\"; \
				}; \
			}; \
			rootPassword = \"$$hashed_root_password\"; \
		}" > secrets.nix; \
	fi
