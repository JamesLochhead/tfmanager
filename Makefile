install-home:
	chmod u+x ./tfmanager ./tgmanager
	mkdir -p "$$HOME/.local/bin/"
	cp -f ./tfmanager ./tgmanager "$$HOME/.local/bin/"
	@echo "Ensure $$HOME/.local/bin is on PATH"
uninstall-home:
	@rm -f "$$HOME/.local/bin/tfmanager" "$$HOME/.local/bin/tgmanager"
install-root:
	chmod 755 ./tfmanager ./tgmanager
	chown root:root ./tfmanager ./tgmanager
	cp -f ./tfmanager ./tgmanager /usr/bin/
uninstall-root:
	rm -rf "/usr/bin/tgmanager" "/usr/bin/tfmanager"
create-release:
	sha256sum tfmanager > SHA256SUMS
	sha256sum tgmanager >> SHA256SUMS
	gpg --sign SHA256SUMS
