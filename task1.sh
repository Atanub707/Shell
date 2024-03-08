#!/bin/bash

# Function to calculate load status
calculate_status() {
    if (( $(echo "$1 > 0.2" | bc -l) )); then
        status="Critical"
    elif (( $(echo "$2 > 0.6" | bc -l) )); then
        status="Extremely Critical"
    elif (( $(echo "$3 > 1.5*$4" | bc -l) )); then
        status="Shutdown Imminent"
    else
        status="Normal"
    fi
    echo "$status"
}

# Main script to monitor system load and write to CSV
while true; do
    load_1min=$(awk '{print $1}' /proc/loadavg)
    load_5min=$(awk '{print $2}' /proc/loadavg)
    load_15min=$(awk '{print $3}' /proc/loadavg)
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    status=$(calculate_status $load_1min $load_15min $load_5min $load_15min_prev)

    echo "$timestamp,$load_1min,$load_5min,$load_15min,$status" >> system_load.csv
    sleep 1
    load_15min_prev=$load_15min
done
