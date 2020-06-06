#!/bin/sh

config_file='/usr/share/nginx/html/config.json'

if [ -f "$config_file" ] && [ -n "$ARA_API_URL" ]; then
  jq ".|{\"apiURL\": \"${ARA_API_URL}\"}" < "${config_file}" > /tmp/config.json
  mv /tmp/config.json "${config_file}"
fi
