rname="minihttpd"
rver="1.30"
rsha256="9c4481802af8dde2e164062185c279e9274525c3af93d014fdc0b80cf30bca6e"
. "${cwrecipe}/acmelabs/acmelabs.sh.common"

eval "
function cwextract_${rname}() {
  cwextract \"${rdlfile}\" \"${cwbuild}\"
  pushd \"${rbdir}\" >/dev/null 2>&1
  find -type f -exec chmod u+rw {} +
  echo '#define HAVE_INT64T' >> port.h
  popd >/dev/null 2>&1
}
"
