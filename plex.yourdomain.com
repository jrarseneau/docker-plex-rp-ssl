# RENAME THIS FILE TO YOUR FQDN
# This file goes into the aforementioned nginx appdata folder:
# In our examples, it would be
# ./appdata/nginx/vhost.d
#
# This file is the base nginx file for your plex server
#
	#listen 80;
	#listen 443 ssl http2; #http2 can provide a substantial improvement for streaming: https://blog.cloudflare.com/introducing-http2/
	server_name plex.arseneau.ca;

	#Faster resolving, improves stapling time. Timeout and nameservers may need to be adjusted for your location Google's have been used here.
	resolver 8.8.4.4 8.8.8.8 valid=300s;
	resolver_timeout 10s;

	#Why this is important: https://blog.cloudflare.com/ocsp-stapling-how-cloudflare-just-made-ssl-30/
	ssl_stapling on;
	ssl_stapling_verify on;

  ssl_ecdh_curve secp384r1;

	#Plex has A LOT of javascript, xml and html. This helps a lot, but if it causes playback issues with devices turn it off. (Haven't encountered any yet)
	gzip on;
	gzip_vary on;
	gzip_min_length 1000;
	gzip_proxied any;
	gzip_types text/plain text/html text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
	gzip_disable "MSIE [1-6]\.";

	#Forward real ip and host to Plex
	proxy_set_header Host $http_host;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_set_header X-Forwarded-Proto $scheme;

	#Websockets
	proxy_http_version 1.1;
	proxy_set_header Upgrade $http_upgrade;
	proxy_set_header Connection "upgrade";

	#Buffering off send to the client as soon as the data is received from Plex.
	proxy_redirect off;
	proxy_buffering off;
