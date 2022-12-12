# apt-repo
Deb package repo
# Add to system
```
mkdir -p /usr/local/share/keyrings
wget -O /usr/local/share/keyrings/eupnea-utils.key https://eupnea-linux.github.io/apt-repo/public.key
echo 'deb [signed-by=/usr/local/share/keyrings/eupnea-utils.key] https://eupnea-linux.github.io/apt-repo/debian_ubuntu kinetic main' > /etc/apt/sources.list.d/eupnea-utils.list
apt update
apt instsall eupnea-system eupnea-utils
```
