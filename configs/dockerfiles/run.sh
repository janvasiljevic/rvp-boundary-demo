#!/bin/sh

# Start the socat so that Boundary can connect to Keycloak 
# (fix for the issuer url error)
socat TCP-LISTEN:8080,fork TCP:keycloak:8080 &
  
# Start Boundary
/usr/local/bin/docker-entrypoint.sh server -config /boundary/boundary.hcl
  
wait -n
  
exit $?