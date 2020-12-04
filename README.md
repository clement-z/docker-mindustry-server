# Mindustry server docker image

## Building the image

Set the contents of `build-and-push.sh` to your liking and run it (or download
the image from [clementz/mindustry-server][docker-hub-link].

## Running

* Docker run command:
```bash
docker run  -it \
            -e PUID=1000 `#optional`\
            -e PGID=1000 `#optional`\
            -p 6567 -p 6567/udp \
            -v /path/to/config:/opt/mindustry/config \
            --name mindustry-server \
            --rm \
            --detach \
            $DOCKER_SRC/mindustry-server:latest

# attach with:
docker attach mindustry-server
```
* Compose file:
```bash
docker-compose up -d

# attach with:
docker attach `docker-compose ps -q`
```

When attached to the container, you can use the shell. Type in `help` for a
list of commands or refer to [the
wiki](https://mindustrygame.github.io/wiki/servers/#dedicated-server-commands).

To host your first game, simply type `host` and join your game once the server
is ready!

## Firewall and port-forward

The game needs one tcp/udp port. The default is `6567`. If you have a firewall,
you should allow incoming/outgoing traffic to/from this port.

If you want to host your game on the internet, you will also most likely need
to set up port-forwarding on your router.

[docker-hub-link](https://mindustrygame.github.io/wiki/servers/#dedicated-server-commands)
