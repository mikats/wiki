#!/bin/bash

/scripts/start_postgresql.sh &
sleep 10
/scripts/start_confluence.sh 
while true; do
    sleep 100
done

