#!/bin/bash 
# wget https://micropython.org/resources/firmware/esp8266-20220618-v1.19.1.bin && wget https://micropython.org/resources/firmware/esp32-20220618-v1.19.1.bin  

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo -e "\nUsage of flash_esp.sh:"
      echo -e  "\nbash flash_esp.sh --model esp8266 --port /dev/ttyUSB0 --bin esp8266-20220618-v1.19.1.bin --hostname myESP8266 --webrepl-passwd 123456 --ssid xxx --wifi-passwd xxx"
      echo -e  "\nOr"
      echo -e  "\nbash flash_esp.sh --model esp32   --port /dev/ttyUSB0 --bin   esp32-20220618-v1.19.1.bin --hostname myESP32   --webrepl-passwd 123456 --ssid xxx --wifi-passwd xxx\n"
      exit 1
      ;;
    --model)
      MODEL="$2" 
      shift; shift;
      ;;  
    --port)
      PORT="$2"
      shift; shift;  #  past argument and value
      ;;
    --bin)
      BIN="$2"
      shift; shift;
      ;;
    --hostname)
      HOSTNAME="$2"
      shift; shift;
      ;;
    --ssid)
      SSID="$2"
      shift; shift;
      ;;
    --wifi-passwd)
      WIFI_PASSWD="$2"
      shift; shift;
      ;; 
    --webrepl-passwd)
      WEBREPL_PASSWD="$2"
      shift; shift;
      ;; 
    -*|--*|*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done 

esptool.py --port $PORT erase_flash || exit

case $MODEL in
  esp32) 
	esptool.py --port $PORT --chip esp32  write_flash -z 0x1000 $BIN
    ;;  
  esp8266)
    esptool.py --port $PORT --baud 460800 write_flash --flash_size=detect 0 $BIN
    ;; 
  *)
    echo "Unknown option $1"
    exit 1
    ;;
esac 

screen -L -Logfile Flash.log -d -m -S esp_foo $PORT 115200 

if [ -z ${WEBREPL_PASSWD+x} ] 
then	
	:;
else 
	sleep 5
	screen -S esp_foo -X stuff "^M"
	screen -S esp_foo -X stuff "import webrepl_setup ^M"
	screen -S esp_foo -X stuff "E^M"
	screen -S esp_foo -X stuff "$WEBREPL_PASSWD^M"
	screen -S esp_foo -X stuff "$WEBREPL_PASSWD^M"
	screen -S esp_foo -X stuff "y^M"
	 
fi 

if [ -z ${SSID+x} ] 
then
	:;
else 
	sleep 5
	screen -S esp_foo -X stuff "^M"
	screen -S esp_foo -X stuff "import network ^M"
	screen -S esp_foo -X stuff "wlan = network.WLAN(network.STA_IF) ^M"
	screen -S esp_foo -X stuff "wlan.active(True) ^M"
	screen -S esp_foo -X stuff "wlan.config(dhcp_hostname='$HOSTNAME') ^M"
	screen -S esp_foo -X stuff "wlan.connect('$SSID', '$WIFI_PASSWD') ^M"
	sleep 10  
	screen -S esp_foo -X stuff "wlan.ifconfig() ^M"
fi

screen -S esp_foo -X stuff "^M"
screen -S esp_foo -X stuff "^M"
screen -S esp_foo -X quit
