#!/bin/bash
INPUT=/home/bruno/Desktop/Bash/bash-csv-location/address.csv
OLDIFS=$IFS
IFS=","
[ ! -f $INPUT ] &while read order_id address street_number neighborhood city state zip_code
do
	# echo "$order_id"   	
	# echo "$address" | sed 's/\"//g'
	SEARCH_STRING="$(echo $address | sed 's/\"//g') $(echo $street_number | sed 's/\"//g') $(echo $neighborhood | sed 's/\"//g') $(echo $city | sed 's/\"//g')"
	echo $SEARCH_STRING
	REPLACE_SEARCH_STRING=$(echo $SEARCH_STRING | sed 's/\ /%20/g')
	
	output=$(curl "http://maps.googleapis.com/maps/api/geocode/json?address=$REPLACE_SEARCH_STRING");
	lat=$(echo "$output" | jq '.results[0].geometry.location.lat');
	lng=$(echo "$output" | jq '.results[0].geometry.location.lng');
	
	echo "$lat , $lng"
   echo "UPDATE sm_orders SET lat='$lat', lng='$lng' WHERE id = $order_id;" >> update_orders.sql

done < $INPUT
IFS=$OLDIFS