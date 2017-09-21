for static musl libraries, **heimdal** likely needs to be built with:

- libedit (external, or with its _\-D_ workaround); readline may flake out
- all DB drivers turned off
- ncurses, openssl, ?

see: http://lists.busybox.net/pipermail/buildroot/2017-July/198737.html
