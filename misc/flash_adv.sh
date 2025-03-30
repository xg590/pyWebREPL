#!/bin/bash 
# wget https://micropython.org/resources/firmware/esp8266-20220618-v1.19.1.bin && wget https://micropython.org/resources/firmware/esp32-20220618-v1.19.1.bin

if [[ $# -eq 0 ]] 
    then 
        echo -e  "bash flash_adv.sh --model esp8266 --port /dev/ttyUSB0 --bin esp8266-20220618-v1.19.1.bin --hostname myESP8266 --webrepl-passwd 123456 --ssid xxx --wifi-passwd xxx"
        exit
fi

while [[ $# -gt 0 ]]; do
  case $1 in
    -h|--help)
      echo -e "\nUsage of flash_adv.sh:"
      echo -e  "\nbash flash_adv.sh --model esp8266 --port /dev/ttyUSB0 --bin esp8266-20220618-v1.19.1.bin --hostname myESP8266 --webrepl-passwd 123456 --ssid xxx --wifi-passwd xxx"
      echo -e  "\nOr"
      echo -e  "\nbash flash_adv.sh --model esp32   --port /dev/ttyUSB0 --bin   esp32-20220618-v1.19.1.bin --hostname myESP32   --webrepl-passwd 123456 --ssid xxx --wifi-passwd xxx\n"
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
echo [INFO] erasing
esptool.py --port $PORT erase_flash || exit
echo [INFO] erased

case $MODEL in
  esp32|32ue) 
    echo [INFO] flashing
	  esptool.py --port $PORT --baud 460800 write_flash 0x1000 $BIN
    echo [INFO] flashed
	  #esptool.py --port $PORT --chip esp32  write_flash -z 0x1000 $BIN
    ;;
  esp32s3) 
    echo [INFO] flashing
	  esptool.py --port $PORT --baud 460800 write_flash 0 $BIN
    echo [INFO] flashed
	  #esptool.py --port $PORT --chip esp32  write_flash -z 0x1000 $BIN
    ;;
  esp8266|d1_mini)
    echo [INFO] flashing
    esptool.py --port $PORT --baud 460800 write_flash --flash_size=detect 0 $BIN
    echo [INFO] flashed
    ;;
  *)
    echo [INFO] Unknown option $1
    exit 1
    ;;
esac 

if [ -z ${WEBREPL_PASSWD+x} ] 
then	
	:;
else
  echo [INFO] sleep 3sec before the MCU restart
  sleep 3
  screen -L -Logfile Flash.log -d -m -S esp_foo $PORT 115200
  echo [INFO] enable webrepl
	screen -S esp_foo -X stuff "^M"
	screen -S esp_foo -X stuff "import webrepl_setup ^M"
	screen -S esp_foo -X stuff "E^M"
	screen -S esp_foo -X stuff "$WEBREPL_PASSWD^M"
	screen -S esp_foo -X stuff "$WEBREPL_PASSWD^M"
	screen -S esp_foo -X stuff "y^M"
  screen -S esp_foo -X quit
  echo [INFO] webrepl enabled
fi

if [ -z ${SSID+x} ] 
then
	:;
else 
  echo [INFO] sleep 3sec before the MCU restart
  sleep 3
  screen -L -Logfile Flash.log -d -m -S esp_foo $PORT 115200
  echo [INFO] setup WIFI $SSID
	screen -S esp_foo -X stuff "^M"
  screen -S esp_foo -X stuff "app = '''import network                      ^M^H" # ^H == backspace
  screen -S esp_foo -X stuff "wlan = network.WLAN(network.STA_IF)            ^M"
  screen -S esp_foo -X stuff "wlan.active(True)                              ^M"
	screen -S esp_foo -X stuff "wlan.config(dhcp_hostname='$HOSTNAME')         ^M"
  screen -S esp_foo -X stuff "wlan.connect('$SSID', '$WIFI_PASSWD')'''     ^M^M"
  screen -S esp_foo -X stuff "with open('boot.py', 'a') as fw:               ^M"
  screen -S esp_foo -X stuff "  fw.write(app)                        ^M^M^M^M^D" 
  screen -S esp_foo -X quit
fi

echo [INFO] Done~
# with open('boot.py') as fr: print(fr.read())




