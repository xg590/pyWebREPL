screen -L -Logfile /tmp/esp_micropython_ifcfg.log -d -m -S esp_foo $1 115200 
 
screen -S esp_foo -X stuff "^M"
screen -S esp_foo -X stuff "import network ^M"
screen -S esp_foo -X stuff "wlan = network.WLAN(network.STA_IF) ^M" 
screen -S esp_foo -X stuff "wlan.ifconfig() ^M" 
screen -S esp_foo -X stuff "^M"
sleep 1
screen -S esp_foo -X quit

cat /tmp/esp_micropython_ifcfg.log
rm  /tmp/esp_micropython_ifcfg.log
