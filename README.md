# apt-repo

Repo for Debian/Ubuntu/Pop!_OS deb packages. Provides the following packages:

* `eupnea-utils`: Packaged eupnea scripts from the [utils](https://github.com/eupnea-project/eupnea-utils) repo.
* `eupnea-system`: Does not install anything per se, but instead includes a postinstall hook which
  executes [system-update.py](https://github.com/eupnea-project/system-update) to upgrade between Depthboot/EupneaOS
  versions.
* `eupnea-mainline-kernel` + `modules` + `headers`: Mainline kernel, modules and headers.
  See [eupnea-mainline-kernel](https://eupnea-project.github.io/docs/project/kernels#mainline-eupnea-kernel)
* `eupnea-chromeos-kernel` + `modules` + `headers`: ChromeOS kernel, modules and headers.
  See [eupnea-chromeos-kernel](https://eupnea-project.github.io/docs/project/kernels#chromeos-eupnea-kernel)
* `libasound2-backport`: Repackaged Ubuntu 22.10 libasound2 and libasound2-data packages for Ubuntu 22.04.
* `keyd`: A key remapping daemon for linux, made by rvaiya. See [keyd](https://github.com/rvaiya/keyd)
* `depthboot-logo`: [Alpine busybox-static](https://dl-cdn.alpinelinux.org/alpine/v3.17/main/x86_64/busybox-static-1.35.0-r29.apk) +
  Depthboot logo boot splash systemd service.

# Add to system

#### Step 1:

* Ubuntu 22.04: `curl -LO https://github.com/eupnea-project/deb-repo/releases/latest/download/eupnea-jammy-keyring.deb`
* Ubuntu 23.10: `curl -LO https://github.com/eupnea-project/deb-repo/releases/latest/download/eupnea-mantic-keyring.deb`
* Debian stable:`curl -LO https://github.com/eupnea-project/deb-repo/releases/latest/download/eupnea-jammy-keyring.deb`

#### Step 2 (for all distros):

```
sudo apt install ./eupnea-*-keyring.deb
sudo apt update -y
```

# Forking this repo

1. Fork only the main branch.
2. Create your own public/private key pair for signing packages with gpg: `gpg --full-gen-key`. This repo uses an
   rsa4096 key, but you can probably use whatever you want. Make sure the key doesn't expire.
3. Export your public key: `gpg --export --armor <key-id>` and add it as a secret variable called `PUBLIC` to your repo.
4. Export your private key: `gpg ---export-secret-keys --armor <key-id>` and add it as a secret variable
   called `PRIVATE` to your repo.
5. Run any action.`
6. Set up pages in the repo settings. Select from branch: `gh-pages` and folder: `/(root)`.
7. Wait for GitHub to finish deploying the page.