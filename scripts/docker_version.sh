#!/bin/bash

y=$(docker --version | grep "Docker version" | awk '{print $3}' | cut -c1-5)
echo $y
