#!/usr/bin/env bash
#
# install busybox index.cgi and an env.cgi environment dumper
#

set -eu

: ${cwtop:="/usr/local/crosware"}
: ${cgidir:="${cwtop}/cgi-bin"}

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

scriptecho "checking and creating ${cgidir}"
test -e "${cgidir}" || mkdir -p "${cgidir}"
test -e "${cgidir}" || failexit "could not create ${cgidir}"
cd "${cgidir}"

# env.cgi just runs set to show the full environment
scriptecho "installing ${cgidir}/env.cgi"
cat >env.cgi<<EOF
#!/usr/bin/env sh
echo "Content-type: text/plain"
echo
set
EOF
chmod 755 env.cgi

# get and extract busybox
scriptecho "fetching busybox"
bbver="$(crosware run-func cwver_busybox)"
crosware run-func cw{fetch,clean,extract}_busybox

# busybox index.cgi for directory listing
# XXX - may break other servers!
scriptecho "installing ${cgidir}/index.cgi"
${CC:-gcc} "${cwtop}/builds/busybox-${bbver}/networking/httpd_indexcgi.c" -o "${cgidir}/index.cgi" -static
# ssi handler
scriptecho "installing ${cgidir}/httpd_ssi"
${CC:-gcc} "${cwtop}/builds/busybox-${bbver}/networking/httpd_ssi.c" -o "${cgidir}/httpd_ssi" -static

scriptecho "cleaning up"
crosware run-func cwclean_busybox
