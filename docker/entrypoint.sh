#! /bin/sh
# Note: adapted from linuxserver.io, thanks to them

PUID=${PUID:-911}
PGID=${PGID:-911}

# Set uid/gid of abc user
groupmod -o -g "$PGID" abc
usermod -o -u "$PUID" abc

echo '
-------------------------------------
Will run as:
-------------------------------------'
echo "
User uid:    $(id -u abc)
User gid:    $(id -g abc)
-------------------------------------
"

# Set owner of mindustry directory
echo "Setting ownership of folders"
chown abc:abc -R /opt/mindustry

# Run server as abc
echo "Starting server"
(
cd /opt/mindustry
su -s '/bin/sh' abc -c "/usr/bin/java -jar /opt/mindustry/server.jar ${MINDUSTRY_ARGS}"
)

echo "Server exited with error code ($?)"
