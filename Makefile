create-release:
	sha256sum tfmanager > SHA256SUMS
	sha256sum tgmanager >> SHA256SUMS
	gpg --sign SHA256SUMS
