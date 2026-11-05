#
# XXX - check and notify if latest is out of date!!!
# XXX - may need to manually clean up...
#
rname="golatest"
rver="1.27.3"
rgobootstrap="127"
rsha256="6e7749035cf360f06b2575d162ea79df9fda8ef671889e5c375f8e50777f26bb"

. "${cwrecipe}/go/gobuildgo.sh"

unset rgobootstrap

# vim: set ft=bash:
