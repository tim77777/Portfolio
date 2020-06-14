#!/bin/bash

#run IpInfo.sh which provides a range of networking information, but pass it through a sed filter so that only the IP addresses are shown
./IpInfo.sh | sed -n '/IP Address/p' 