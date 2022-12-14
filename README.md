# apt-repo
Deb package repo
# Add to system
```
sudo mkdir -p /usr/local/share/keyrings
sudo wget -O /usr/local/share/keyrings/eupnea.key https://eupnea-linux.github.io/apt-repo/public.key
echo 'deb [signed-by=/usr/local/share/keyrings/eupnea.key] https://eupnea-linux.github.io/apt-repo/debian_ubuntu kinetic main' > /etc/apt/sources.list.d/eupnea.list
sudo apt update
sudo apt install eupnea-system eupnea-utils
```
