# tfmanager

## About

Two simple Bash scripts that download and install Terraform or Terragrunt as
securely as possible. The scripts can either be run as root, to install the
applications system-wide, or a normal user, to install the applications to the
users home directory.

Each script takes just over a second to download and install the respective
application on my local machine.

Checksums are checked for both applications. GPG signatures are checked only for
Terraform. The Terragrunt team does not seem to sign their releases.

Motivation:

- I had bad experiences with alternatives for managing different versions of
  Terraform/Terragrunt on my local machine. The applications were excessively
  complicated and weird things were happening.

- I wanted a solution that was extremely simple to audit and checked
  checksums/GPG signatures (where available).

- I wanted something I could also use to install Terraform/Terragrunt in
  CI/CD pipelines and containers.

- Installing Terraform/Terragrunt in CI/CD pipelines and containers via package
  managers can be very slow. This method is quick.

## Platforms

- I am aiming to support your bog standard, relatively up-to-date, mainstream
  Linux with GNU coreutils. i.e. Ubuntu, Debian, RHEL (and similar), Amazon
  Linux, Fedora, and OpenSUSE. PRs for older/other distros may be accepted
  provided they don't complicate the code base or have gotchas.

- PRs for MacOS, BSDs, and other *nix may be accepted provided they don't
  complicate the code base or have gotchas. I am quite sure the code base
  already uses some flags that will mean it needs some work for other Unix or
  Unix-like operating systems. 

- Windows will definitely not be supported.

## Requirements

- Bash.
- Common Unix utilities (e.g. coreutils).
- sha256sum.
- gpg.
- curl.
- grep.

## Installation/usage

I suggest reading "Verify files" first.

The scripts can be used anywhere on the file system or added to $PATH. They are
both single file scripts.

Make them executable:
```
chmod u+x ./tfmanager
chmod u+x ./tgmanager
```

Usage:
```
tfmanager [ TERRAFORM_VERSION | --help ]
tgmanager [ TERRAGRUNT_VERSION | --help ]
```

Suggested installation method in a home directory (assuming you're using "$HOME/.bashrc"):
```
mkdir -p "$HOME/.local/bin/"
mv -f ./tfmanager ./tgmanager "$HOME/.local/bin/"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

Suggested system-wide installation method:
```
# chmod 755 ./tfmanager ./tgmanager
# chown root:root ./tfmanager ./tgmanager
# mv -f ./tfmanager ./tgmanager /usr/bin/
```

### Uninstall/upgrade

Simply remove or upgrade ./tfmanager and ./tgmanager.

## Verify files

Import my public GPG key:
```
$ gpg --import res/public-key.asc
```

Check my signature on the SHA256SUMS file:
```
$ gpg --verify SHA256SUMS.gpg 
gpg: Signature made Tue 14 Jun 2022 22:40:49 BST
gpg:                using RSA key 36938B32F54C46FC153148CA768CE6B444445D37
gpg: Good signature from "James Lochhead <REDACTED>" [ultimate]
gpg:                 aka "James Lochhead <REDACTED>" [ultimate]
Primary key fingerprint: B098 DF51 A576 2712 1177  DC3C 180A B694 A7EF 5FC0
     Subkey fingerprint: 3693 8B32 F54C 46FC 1531  48CA 768C E6B4 4444 5D37
```

If you see "Good signature from", you are good to go.

Check checksums are OK:
```
$ sha256sum -c SHA256SUMS 
tfmanager: OK
tgmanager: OK
```

#### Explanation

If the GPG signature says "Good signature from", we have verified that my
private key was used to sign the  SHA256SUMS file, so we can be sure the file
came from me (unless someone stole my private key). Think of it like a seal on a
letter.

If the checksums say OK, it means they are identical to when they were on my
local machine, at the point of release.

In other words, we can be fairly sure the files are from me and no one has
tampered with them.

If you want to get really particular about security, you should really audit the
code at this point. The code base is small to make this easy.
