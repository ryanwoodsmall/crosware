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

# env.awk - same but awk
scriptecho "installing ${cgidir}/env.awk"
cat >env.awk<<EOF
#!${cwsw}/busybox/current/bin/awk -f
BEGIN {
    printf("Status: 200 OK\\n");
    printf("Content-type: text/plain\\n\\n");
    for ( key in ENVIRON ) {
        print key " : " ENVIRON[key] | "sort";
    }
}
EOF
chmod 755 env.awk

# XXX - should njs/qjs be application/json?

# env.njs - same but javascript/json (with njs)
scriptecho "installing ${cgidir}/env.njs"
cat >env.njs<<EOF
#!${cwsw}/njs/current/bin/njs
console.log("Status: 200 OK")
console.log("Content-type: text/plain")
console.log("")
console.log(JSON.stringify(process.env))
EOF
chmod 755 env.njs

# env.qjs - quickjs
scriptecho "installing ${cgidir}/env.qjs"
cat >env.qjs<<EOF
#!${cwsw}/quickjs/current/bin/qjs --std
console.log("Status: 200 OK")
console.log("Content-type: text/plain")
console.log("")
console.log(JSON.stringify(std.getenviron()))
EOF
chmod 755 env.qjs

# tar.cgi serves a .tar of common git files, new/updated recipes, etc.
scriptecho "installing ${cgidir}/tar.cgi"
cat >tar.cgi<<EOF
#!/usr/bin/env bash
. /usr/local/crosware/etc/vars
: \${g:="git"}
cd "\${cwtop}"
gitfiles="\$(\${g} grep -il . 2>/dev/null || true)"
echo "Content-type: application/x-tar"
echo
tar -cf - \${gitfiles} bin/ recipes/ scripts/ etc/functions etc/profile etc/vars
EOF
chmod 755 tar.cgi

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
