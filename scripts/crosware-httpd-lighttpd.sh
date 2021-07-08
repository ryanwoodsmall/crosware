#!/usr/bin/env bash
#
# start lighttpd http+https at the crosware root on ports 18081 and 18443
#

set -eu

: ${cwtop:="/usr/local/crosware"}
: ${httpport:="18081"}
: ${httpsport:="18443"}
: ${httproot:="${cwtop}"}
: ${lighttpd_key:="${cwtop}/tmp/lighttpd_key.pem"}
: ${lighttpd_cert:="${cwtop}/tmp/lighttpd_cert.pem"}
: ${lighttpd_conf:="${cwtop}/tmp/lighttpd.conf"}
: ${brssl_keysize:="2048"}
: ${x509cert_args:=""}
: ${TS:="$(date '+%Y%m%d%H%M%S')"}

scriptname="$(basename ${BASH_SOURCE[0]})"

function failexit() {
  echo "${scriptname}: ${@}" 1>&2
  exit 1
}

function scriptecho() {
  echo "${scriptname}: ${@}"
}

test -e "${cwtop}/etc/profile" || failexit "no profile to source"
. "${cwtop}/etc/profile"

if ! $(which lighttpd brssl x509cert >/dev/null 2>&1) ; then
  scriptecho "missing a prereq (lighttpd brssl x509cert)"
  for i in bearssl x509cert lighttpd ; do
    crosware check-installed ${i} || crosware install ${i}
  done
  . "${cwtop}/etc/profile"
fi

if [ ! -e "${lighttpd_key}" ] ; then
  scriptecho "generating ${lighttpd_key} with brssl"
  brssl skey -gen rsa:"${brssl_keysize}" -rawpem "${lighttpd_key}"
  if [ -e "${lighttpd_cert}" ] ; then
    scriptecho "moving ${lighttpd_cert} to ${lighttpd_cert}.PRE-${TS} on new key gen"
    mv ${lighttpd_cert}{,PRE-${TS}}
  fi
fi

if [ ! -e "${lighttpd_cert}" ] ; then
  scriptecho "generating ${lighttpd_cert} with x509cert"
  x509cert ${x509cert_args} -a "$(hostname)" "${lighttpd_key}" CN="$(hostname)" | tee "${lighttpd_cert}"
fi

if [ ! -e "${lighttpd_conf}" ] ; then
  scriptecho "generating ${lighttpd_conf}"
  cat >"${lighttpd_conf}"<<EOF
server.document-root = "${httproot}"
server.upload-dirs = ("${cwtop}/tmp")
server.port = ${httpport}

dir-listing.activate = "enable"

server.modules += ("mod_mbedtls")
\$SERVER["socket"] == ":${httpsport}" {
    ssl.engine = "enable"
    ssl.pemfile = "${lighttpd_cert}"
    ssl.privkey = "${lighttpd_key}"
}

server.modules += ("mod_status")
status.status-url = "/server-status"

server.modules += ("mod_alias")
server.modules += ("mod_cgi")
\$HTTP["url"] =~ "^/cgi-bin" {
    cgi.assign = ( "" => "" )
}

server.modules += ("mod_webdav")
\$HTTP["url"] =~ "^/tmp($|/)" {
    webdav.activate = "enable"
    webdav.is-readonly = "disable"
    webdav.sqlite-db-name = "${cwtop}/tmp/lighttpd_webdav.db"
}

mimetype.assign += (".png"  => "image/png")
mimetype.assign += (".jpg"  => "image/jpeg")
mimetype.assign += (".jpeg" => "image/jpeg")
mimetype.assign += (".html" => "text/html")
mimetype.assign += (".txt"  => "text/plain")
EOF
fi

scriptecho "checking config"
lighttpd -tt -f "${lighttpd_conf}"

scriptecho "starting lighttpd on http:${httpport} and https:${httpsport} with root:${httproot}"
lighttpd -D -f "${lighttpd_conf}"
