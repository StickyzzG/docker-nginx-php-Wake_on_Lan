#!/bin/bash

##############
#
# This script will set the required kernel network settings to 
# allow broadcast traffic to be sent from a docker network
# to another network.
# 
# This sets using both "sysctl -w" as well as configuring a file in
# "/etc/sysctl.d/" so the change will persist a reboot. 
#
##############

# List available Docker networks
echo "Available Docker networks:"
sudo docker network ls

# Prompt user to choose a network
echo "Enter the number of the network you want to use:"
echo "1. bridge"
echo "2. host"
echo "3. none"
read network_choice

# Assign network ID based on user's choice
if [ "$network_choice" = "1" ]; then
  chosen_network_id=$(docker network ls -qf "name=bridge")
elif [ "$network_choice" = "2" ]; then
  chosen_network_id=$(docker network ls -qf "name=host")
elif [ "$network_choice" = "3" ]; then
  chosen_network_id=$(docker network ls -qf "name=none")
else
  echo "Invalid choice. Exiting."
  exit 1
fi

# The name of the network the docker container will be connected to
DOCKER_NETWORK=$chosen_network_id

# Disable the setting to ignore echo broadcasts
sudo sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=0
echo '# Disable the setting to ignore echo broadcasts' | sudo tee /etc/sysctl.d/97-docker-broadcast.conf
echo 'net.ipv4.icmp_echo_ignore_broadcasts=0' | sudo tee -a /etc/sysctl.d/97-docker-broadcast.conf

# Enabling broadcast forwarding for "all" interfaces, 
# although it seems this needs used in combination with specific interfaces
sudo sysctl -w net.ipv4.conf.all.bc_forwarding=1
echo '# Enabling broadcast forwarding for "all" interfaces' | sudo tee -a /etc/sysctl.d/97-docker-broadcast.conf
echo 'net.ipv4.conf.all.bc_forwarding=1' | sudo tee -a /etc/sysctl.d/97-docker-broadcast.conf


# Find the subnet for the docker network
subnet=$(sudo docker network inspect "$DOCKER_NETWORK" | jq --raw-output .[0].IPAM.Config[0].Subnet)

if [ ! -z subnet ]; then

    echo "Got subnet $subnet"

    # Find the network interface
    interface=$(ip route | grep "$subnet" | cut -d ' ' -f3)

    if [ ! -z interface ]; then
        echo "Got interface $interface"

        # Check the setting value to check we are substituting correctly
        sudo sysctl -w net.ipv4.conf.${interface}.bc_forwarding=1
        echo '# Check the setting value to check we are substituting correctly' | sudo tee -a /etc/sysctl.d/97-docker-broadcast.conf
        echo "net.ipv4.conf.${interface}.bc_forwarding=1" | sudo tee -a /etc/sysctl.d/97-docker-broadcast.conf
    else
        echo "Could not determine the network interface for $subnet"
    fi
else
    echo "Could not determine the subnet for $DOCKER_NETWORK"
fi


