#!/bin/bash
echo "RAM: $(free -m | awk '/Mem:/ {print $3"/"$2" MB"}')"
