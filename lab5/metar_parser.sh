#!/bin/bash

curl -s "https://aviationweather.gov/api/data/metar?ids=KMCI&format=json&taf=false&hours=12&bbox=40%2C-90%2C45%2C-85" > aviation.json

jq -r '.[].receiptTime' aviation.json | head -6

temps=($(jq -r '.[].temp' aviation.json | grep -E '^-?[0-9]+$'))
total=0
count=0

for temp in "${temps[@]}"; do
	total=$((total + temp))
	((count++))
done

if [ "$count" -gt 0 ]; then
	avg_temp=$(echo "scale=1; $total / $count" | bc)
else
	avg_temp="N/A"
fi

echo "Average Temperature: $avg_temp"

cloudy_hours=0
total_hours=0

while read -r cloud; do
    ((total_hours++))
    if [[ "$cloud" != "CLR" ]]; then
        ((cloudy_hours++))
    fi
done < <(jq -r '.[].cloud' aviation.json)

mostly_cloudy="false"
if [ "$cloudy_hours" -gt "$((total_hours / 2))" ]; then
    mostly_cloudy="true"
fi

echo "Mostly Cloudy: $mostly_cloudy"

