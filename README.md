# apt-repo

Repo for Debian/Ubuntu/Pop!_OS deb packages. Provides the following packages:

* `eupnea-utils`: Packaged eupnea scripts from the [postinstall](https://github.com/eupnea-linux/postinstall-scripts)
  and [audio](https://github.com/eupnea-linux/audio-scripts/) repos.
* `eupnea-system`: Does not install anything per se, but instead includes a postinstall hook, which
  executes [system-update.py](https://github.com/eupnea-linux/system-update) to upgrade between Depthboot/EupneaOS
  versions.

# Add to system

```
sudo mkdir -p /usr/local/share/keyrings
sudo wget -O /usr/local/share/keyrings/eupnea.key https://eupnea-linux.github.io/apt-repo/public.key
echo 'deb [signed-by=/usr/local/share/keyrings/eupnea.key] https://eupnea-linux.github.io/apt-repo/debian_ubuntu kinetic main' > /etc/apt/sources.list.d/eupnea.list
sudo apt update
sudo apt install eupnea-system eupnea-utils
```
