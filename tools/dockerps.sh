#!/bin/bash

Help()
{
   # Display Help
   echo "Displays docker running containers"
   echo
   echo "Syntax: dockerps [-h|n]"
   echo "options:"

   options=$(echo -e "\t-n,--net\tAlso displays IP and binded ports."
   echo -e "\t-h,--help\tPrint this Help.")
   echo "$options" | column -t -s$'\t'
   echo
}

display_network=0

while getopts ":hn-:" option; do
   case $option in
      -)
        case "${OPTARG}" in
          net)
            display_network=1
            ;;
          help)
            Help
            exit
            ;;
        esac;;
      h) # display Help
         Help
         exit;;
      n) # Enter a name
         display_network=1;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

list=$(docker ps --format "table {{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.Names}}")

table=$(
while IFS= read -r line; do
    if [ $display_network -eq 1 ]; then
      ID=$(echo "$line" | cut -d ' ' -f 1)
      if [ "$ID" = "CONTAINER" ]; then
              echo -e "$line\tIP\tPORTS"
              continue
      fi

      CONTAINER_INFO=$(docker inspect "$ID")
      IP=$(echo "$CONTAINER_INFO" | jq -r '.[].NetworkSettings.Networks | to_entries[].value.IPAddress')
      PORTS=$(echo "$CONTAINER_INFO" | jq -r '.[].NetworkSettings.Ports | keys[] as $k | "\($k|sub("/tcp";""))->\(.[$k][]|select(.HostIp=="0.0.0.0")|.HostPort)"' 2>/dev/null | paste -sd',')

      line="$line\t$IP\t$PORTS"
    fi
    echo -e "$line"

done <<< "$list"
)

echo "$table" | column -t -s$'\t'