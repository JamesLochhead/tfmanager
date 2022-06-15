# tfmanager

## About

Two simple Bash scripts that download and install AMD64 Terraform or Terragrunt
as securely as possible. The scripts can either be run as root, to install the
applications system-wide, or a normal user, to install the applications to the
user's home directory.

Each script takes just over a second to download and install the respective
application on my local machine.

Checksums are checked for both applications. GPG signatures are checked for
Terraform only. The Terragrunt team does not seem to sign their releases.

Motivation:

- I had bad experiences with alternatives for managing different versions of
  Terraform/Terragrunt on my local machine. The applications were excessively
  complicated and weird things were happening.

- I wanted a solution that was extremely simple to audit and checked
  checksums/GPG signatures (where available).

- I wanted something I could also use to install Terraform/Terragrunt in
  CI/CD pipelines and containers.

- Installing Terraform/Terragrunt in CI/CD pipelines and containers via package
  managers can be very slow (30s+). This method is quick (less than 2s).

- Shell scripts were used as interpreters/compilers are often not
  available/advisable in containers.

## Platforms and architectures

- I am aiming to support your bog standard, relatively up-to-date, mainstream
  Linux with GNU coreutils. i.e. Ubuntu, Debian, RHEL (and similar), Amazon
  Linux, Fedora, and OpenSUSE. PRs for older/other distros may be accepted
  provided they don't complicate the code base or have gotchas.

- PRs for MacOS, BSDs, and other *nix may be accepted provided they don't
  complicate the code base or have gotchas. I am quite sure the code base
  already uses some flags that will mean it needs some work for other Unix or
  Unix-like operating systems. 

- Windows will definitely not be supported.

- Additional architectures may work with minor modifications. See the variables
  at the top of the scripts.

## Warning

tfmanager is stateless and assumes it is the only script managing
Terraform/Terragrunt on the system. It will overwrite existing binaries. The
overwriting behaviour is intentional to keep the scripts simple.

If you have either application installed via other means, please uninstall
first.

## Usage

Usage:

```
tfmanager [ TERRAFORM_VERSION | --help ]
tgmanager [ TERRAGRUNT_VERSION | --help ]
```

For example:

```
$ ./tfmanager 1.2.2
```

## Requirements

- Bash.
- Common Unix utilities (e.g. coreutils).
- sha256sum.
- gpg.
- curl.
- grep.
- mktemp and a writable `/tmp/` directory.

Terraform and Terragrunt installed via other means may interfere depending on
precedence on PATH.

## Install locations

By default, for non-root users, Terraform and Terragrunt are installed to:
```
$HOME/.local/bin
```

By default, for the root users, Terraform and Terragrunt are installed to:
```
/usr/bin
```

This is easily customizable by simply changing the variables at the top of each
file.

## Installation

I suggest reading "Verify files" first.

The scripts can be used anywhere on the file system or added to $PATH. They are
both single file scripts.

Suggested installation method in a home directory (assuming you're using "$HOME/.bashrc"):
```
$ chmod u+x ./tfmanager ./tgmanager
$ mkdir -p "$HOME/.local/bin/"
$ cp -f ./tfmanager ./tgmanager "$HOME/.local/bin/"
$ echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
$ source "$HOME/.bashrc"
```

Suggested system-wide installation method:
```
# chmod 755 ./tfmanager ./tgmanager
# chown root:root ./tfmanager ./tgmanager
# cp -f ./tfmanager ./tgmanager /usr/bin/
```

### Uninstall

`cd` to the directory where you installed the scripts and: 

```
rm ./tfmanager
rm ./tgmanager
```

### Upgrade

Complete the installation steps again and simply overwrite the files.

## Verify files

Import my public GPG key:
```
$ gpg --import res/public-key.asc
```

Check the signature on the SHA256SUMS file matches my public key:
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
local machine.

In other words, we can be fairly sure the files are from me and no one has
tampered with them.

If you want to get really particular about security, you should really audit the
code at this point. The code base is small to make this easy. I also encourage
forking if you take the time to audit.

## Debugging

Setting the environment variable `TFMANAGER_DEBUG=true` activates a debugging
mode. 

```
export TFMANAGER_DEBUG=true
```

Debug messages are printed to stderr.

I recommend adding this environment variable as `TFMANAGER_DEBUG=false` on CI/CD
pipelines, such that debugging mode can be toggled when necessary.
