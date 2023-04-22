# apt-repo

Repo for Debian/Ubuntu/Pop!_OS deb packages. Provides the following packages:

* `eupnea-utils`: Packaged eupnea scripts from the [utils](https://github.com/eupnea-linux/eupnea-utils)
  and [audio](https://github.com/eupnea-linux/audio-scripts/) repos.
* `eupnea-system`: Does not install anything per se, but instead includes a postinstall hook, which
  executes [system-update.py](https://github.com/eupnea-linux/system-update) to upgrade between Depthboot/EupneaOS
  versions.
* `eupnea-mainline-kernel` + `modules` + `headers`: Mainline kernel, modules and headers.
  See [eupnea-mainline-kernel](https://eupnea-linux.github.io/docs/project/kernels#mainline-eupnea-kernel)
* `eupnea-chromeos-kernel` + `modules` + `headers`: ChromeOS kernel, modules and headers.
  See [eupnea-chromeos-kernel](https://eupnea-linux.github.io/docs/project/kernels#chromeos-eupnea-kernel)
* `libasound2-backport`: Repackaged Ubuntu 22.10 libasound2 and libasound2-data packages for Ubuntu 22.04.
* `keyd`: A key remapping daemon for linux, made by rvaiya. See [keyd](https://github.com/rvaiya/keyd)

# Add to system

```
mkdir -p /usr/local/share/keyrings
wget -O /usr/local/share/keyrings/eupnea.key https://eupnea-linux.github.io/apt-repo/public.key
echo 'deb [signed-by=/usr/local/share/keyrings/eupnea.key] https://eupnea-linux.github.io/apt-repo/debian_ubuntu lunar main' > /etc/apt/sources.list.d/eupnea.list
apt update
apt install eupnea-system eupnea-utils
```
