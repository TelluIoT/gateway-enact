#!/bin/bash

# Checking for network by pingging google DNS server 8.8.8.8
ping -W 5 -c 1 8.8.8.8 > /dev/null
