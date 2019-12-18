# mailcow-cert-watcher
Restarts mailcow containers which use the ssl-certificate when it gets changed

# background
Since [mailcow-traefik-acme-adapter](https://github.com/jovobe/mailcow-traefik-acme-adapter) is not working with the
new Traefik v2, I created this watcher to restart the [mailcow-dockerized](https://github.com/mailcow/mailcow-dockerized)
containers which uses the ssl certificate when the certificate file(s) get updated.

This works great with the [traefik-certs-dumper](https://github.com/humenius/traefik-certs-dumper/) which extracts the
ssl certificate from the acme.json of traefik

# usage
Mount your mailcow-ssl-certificate folder into `/ssl-folder` and the docker-socket to the default docker-socket location
(`/var/run/docker.sock`)
```yml
version: "3.7"
services:
  mailcow-cert-watcher:
    image: sarsum/mailcow-cert-watcher
    volumes:
      - /opt/mailcow-dockerized/data/assets/ssl:/ssl-folder:rw
      - /var/run/docker.sock:/var/run/docker.sock:rw
```

# Problems?
If you need help using this image, have suggestions or want to report a problem, feel free to open an issue on GitHub!