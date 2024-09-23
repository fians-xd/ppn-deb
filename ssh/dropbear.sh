# Deteksi OS
if [ -f /etc/debian_version ]; then
    OS=$(cat /etc/os-release | grep "^ID=" | cut -d'=' -f2)

    if [ "$OS" == "debian" ]; then
        echo "Detected OS: Debian"
        wget "https://raw.githubusercontent.com/fians-xd/AutoScript.vpn/master/dropbear/dropbear-2018.76.debian.tar.bz2"
        tar -xvjf dropbear-2018.76.debian.tar.bz2
        cd dropbear-2018.76
        ./configure --prefix=/usr --sbindir=/usr/sbin
        make
        make install
        sleep 0.8
        cd
        rm -rf dropbear-2018.76.debian.tar.bz2 dropbear-2018.76
      
    elif [ "$OS" == "ubuntu" ]; then
        echo "Detected OS: Ubuntu"
        wget "https://raw.githubusercontent.com/fians-xd/AutoScript.vpn/master/dropbear/dropbear-2019.78-ubuntu.tar.bz2"
        tar -xvjf dropbear-2019.78-ubuntu.tar.bz2
        cd dropbear-2019.78
        ./configure --prefix=/usr --sbindir=/usr/sbin
        make
        make install
        sleep 0.8
        cd
        rm -rf dropbear-2019.78-ubuntu.tar.bz2 dropbear-2019.78
      
    else
        echo "Unsupported OS: $OS"
    fi
else
    echo "This script only supports Debian or Ubuntu-based systems."

 # Cek dan buat direktori jika belum ada
if [ ! -d "/etc/default" ]; then
    mkdir -p /etc/default
fi

mkdir -p /etc/init.d
mkdir -p /etc/dropbear
mkdir /etc/dropbear/log

# Membuat kunci RSA 2048-bit
/usr/bin/dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
# Membuat kunci ECDSA
/usr/bin/dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
# Membuat kunci ED25519
/usr/bin/dropbearkey -t dss -f /etc/dropbear/dropbear_dss_host_key

chmod +x /etc/dropbear/dropbear_rsa_host_key /etc/dropbear/dropbear_ecdsa_host_key /etc/dropbear/dropbear_dss_host_key

#touch /etc/dropbear/log/main
# Buat file run dengan konten yang diinginkan
cat > /etc/dropbear/log/run <<-END
#!/bin/sh
exec chpst -udropbearlog svlogd -tt ./main
END

# Buat file run dengan konten yang diinginkan
cat > /etc/dropbear/run <<-END
#!/bin/sh
exec 2>&1
exec dropbear -d ./dropbear_dss_host_key -r ./dropbear_rsa_host_key -F -E -p 22
END

cat > /etc/init.d/dropbear <<-END
#!/bin/sh
### BEGIN INIT INFO
# Provides:          dropbear
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Lightweight SSH server
# Description:       Init script for drobpear SSH server.  Edit
#                    /etc/default/dropbear to configure the server.
### END INIT INFO
#
# Do not configure this file. Edit /etc/default/dropbear instead!
#

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/sbin/dropbear
NAME=dropbear
DESC="Dropbear SSH server"
DEFAULTCFG=/etc/default/dropbear

DROPBEAR_PORT=22
DROPBEAR_EXTRA_ARGS=
NO_START=0

set -e

. /lib/lsb/init-functions

cancel() { echo "$1" >&2; exit 0; };
test ! -r $DEFAULTCFG || . $DEFAULTCFG
test -x "$DAEMON" || cancel "$DAEMON does not exist or is not executable."
test ! -x /usr/sbin/update-service || ! update-service --check dropbear ||
  cancel 'The dropbear service is controlled through runit, use the sv(8) program'

[ ! "$DROPBEAR_BANNER" ] || DROPBEAR_EXTRA_ARGS="$DROPBEAR_EXTRA_ARGS -b $DROPBEAR_BANNER"
[ ! -f "$DROPBEAR_RSAKEY" ]   || DROPBEAR_EXTRA_ARGS="$DROPBEAR_EXTRA_ARGS -r $DROPBEAR_RSAKEY"
[ ! -f "$DROPBEAR_DSSKEY" ]   || DROPBEAR_EXTRA_ARGS="$DROPBEAR_EXTRA_ARGS -r $DROPBEAR_DSSKEY"
[ ! -f "$DROPBEAR_ECDSAKEY" ] || DROPBEAR_EXTRA_ARGS="$DROPBEAR_EXTRA_ARGS -r $DROPBEAR_ECDSAKEY"
test -n "$DROPBEAR_RECEIVE_WINDOW" || \
  DROPBEAR_RECEIVE_WINDOW="65536"

case "$1" in
  start)
        test "$NO_START" = "0" ||
        cancel "Starting $DESC: [abort] NO_START is not set to zero in $DEFAULTCFG"

        echo -n "Starting $DESC: "
        start-stop-daemon --start --quiet --pidfile /var/run/"$NAME".pid \
          --exec "$DAEMON" -- -p "$DROPBEAR_PORT" -W "$DROPBEAR_RECEIVE_WINDOW" $DROPBEAR_EXTRA_ARGS
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/"$NAME".pid
        echo "$NAME."
        ;;
  restart|force-reload)
        test "$NO_START" = "0" ||
        cancel "Restarting $DESC: [abort] NO_START is not set to zero in $DEFAULTCFG"

        echo -n "Restarting $DESC: "
        start-stop-daemon --stop --quiet --oknodo --pidfile /var/run/"$NAME".pid
        sleep 1
        start-stop-daemon --start --quiet --pidfile /var/run/"$NAME".pid \
          --exec "$DAEMON" -- $DROPBEAR_KEYS -p "$DROPBEAR_PORT" -W "$DROPBEAR_RECEIVE_WINDOW" $DROPBEAR_EXTRA_ARGS
        echo "$NAME."
        ;;
  status)
                status_of_proc -p /var/run/"$NAME".pid $DAEMON $NAME && exit 0 || exit $?
        ;;
  *)
        N=/etc/init.d/$NAME
        echo "Usage: $N {start|stop|status|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0
END

# Berikan izin eksekusi pada file run
chmod +x /etc/init.d/dropbear
chmod +x /etc/dropbear/run 
chmod +x /etc/dropbear/log/run
chmod +x /etc/dropbear/log/main

cat > /etc/default/dropbear <<-END
# disabled because OpenSSH is installed
# change to NO_START=0 to enable Dropbear
NO_START=0
# the TCP port that Dropbear listens on
DROPBEAR_PORT=143

# any additional arguments for Dropbear
DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"

# specify an optional banner file containing a message to be
# sent to clients before they connect, such as "/etc/issue.net"
DROPBEAR_BANNER="/etc/issue.net"

# RSA hostkey file (default: /etc/dropbear/dropbear_rsa_host_key)
#DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"

# DSS hostkey file (default: /etc/dropbear/dropbear_dss_host_key)
#DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"

# ECDSA hostkey file (default: /etc/dropbear/dropbear_ecdsa_host_key)
#DROPBEAR_ECDSAKEY="/etc/dropbear/dropbear_ecdsa_host_key"

# Receive window size - this is a tradeoff between memory and
# network performance
DROPBEAR_RECEIVE_WINDOW=65536
END
chmod +x /etc/default/dropbear