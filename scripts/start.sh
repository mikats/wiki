#!/bin/bash

/scripts/start_postgresql.sh &
/scripts/start_confluence.sh 
while true; do
    sleep 100
done

