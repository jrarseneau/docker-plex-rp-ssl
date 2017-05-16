# docker-plex-rp-ssl
Plex in Docker, with nginx-proxy, let's encrypt for use with Cloud Flare

## 1. Create Docker network
You need to create a docker network that your containers will communicate on for the reverse proxy.

In these examples, we will use the `proxy-tier` network.
`docker create network proxy-tier`

## 2. Cloud Flare Configuration

### Crypto Tab
SSL: **Full (Strict)**  
HTTP Strict Transport Security: **Disabled** (you can enable, but beware, not really necessary).  
Opportunistic Encryption: **On**  
TLS 1.3: **Enabled+0RTT**  
Automatic HTTP Rewrites: **Off**  

### Firewall Tab
Rate Limiting: **Off**
Securty Level: **Essentially Off** (I turned this off because didn't want users to potentialy be challenged by Cloudflare which would break Plex. You may be able to play with this)
Challenge passage: **30 minutes**

### DNS Tab
Create a new **A** Record for your Plex Server and point to your IP. You can try testing with the cloud icon "grey" (bypass cloudflare) to ensure your setup it working, then enable it when you're sure.

### Caching Tab
Caching Level: **Standard** (you can play with this. Some use **No Query String**). YMMV
Browser Cache Expiration: **4 Hours**
Always Online: **Off** (you may want to leave this **On** if you serve other sites from your domain)
Development Mode: **Off*

### Network Tab
HTTP/2 SPDY: **On**
IPv6: **On** (change this depending on your environment)
WebSockets: **On**
IP GeoLocation: **On**
Maximum Upload Size: **100MB**

