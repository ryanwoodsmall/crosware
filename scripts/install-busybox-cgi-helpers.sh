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

# env.njs - same but javascript/json (with njs)
scriptecho "installing ${cgidir}/env.njs"
cat >env.njs<<EOF
#!${cwsw}/njs/current/bin/njs
console.log("Status: 200 OK");
console.log("Content-type: application/json");
console.log("");
console.log(JSON.stringify(process.env));
EOF
chmod 755 env.njs

# env.qjs - quickjs
scriptecho "installing ${cgidir}/env.qjs"
cat >env.qjs<<EOF
#!${cwsw}/quickjs/current/bin/qjs --std
console.log("Status: 200 OK");
console.log("Content-type: application/json");
console.log("");
console.log(JSON.stringify(std.getenviron()));
EOF
chmod 755 env.qjs

# env.jojq - json w/jo+jq
# XXX exclude long FLAG/PKG_CONF_...; chokes up jo
scriptecho "installing ${cgidir}/env.jojq"
cat >env.jojq<<EOF
#!/usr/bin/env sh
: \${jo:="/usr/local/crosware/software/jo/current/bin/jo"}
: \${jq:="/usr/local/crosware/software/jq/current/bin/jq"}
echo "Content-type: application/json"
echo
( tr '\\0' '\\n' < /proc/\$\$/environ | grep -vE -- '^(PKG_CONF|((CPP|LD)FLAGS|PATH)=)' ; echo JO_VER=\$(\${jo} -V) ; echo JQ_VER=\$(\${jq} --version) ) \
  | ( \${jo} -p -- | \${jq} -M -S . ) 2>/dev/null
EOF
chmod 755 env.jojq

# common javascript on jvm
declare -a jvmjs
jvmjs+=( 'var eka = java.lang.System.getenv().keySet().toArray();' )
jvmjs+=( 'var pka = java.lang.System.getProperties().keySet().toArray();' )
jvmjs+=( 'var e = {};' )
jvmjs+=( 'var p = {};' )
jvmjs+=( 'for (k in eka) { e[eka[k]] = java.lang.System.getenv(eka[k]); }' )
jvmjs+=( 'for (k in pka) { p[pka[k]] = java.lang.System.getProperty(pka[k]); }' )
jvmjs+=( 'e["JAVA_PROPERTIES"] = p;' )
jvmjs+=( 'print("Status: 200 OK");' )
jvmjs+=( 'print("Content-type: application/json");' )
jvmjs+=( 'print("");' )
jvmjs+=( 'print(JSON.stringify(e));' )

# env.nashorn - nashorn javascript on java jvm
# XXX - nashorn has an '$ENV' object in scripting mode; should be same as java.lang.System.getenv()
: ${JAVA_HOME:=""}
if [ ! -z "${JAVA_HOME}" ] ; then
  scriptecho "installing ${cgidir}/env.nashorn"
  cat >env.nashorn<<EOF
#!/usr/bin/env bash
export _JAVA_OPTIONS='-Djava.io.tmpdir=/usr/local/crosware/tmp -Djava.awt.headless=true -XX:-UsePerfData'
{
$(for k in ${!jvmjs[@]} ; do printf '%s\n' "${jvmjs[${k}]}" | sed "s,^,  echo ',g;s,$,',g" ; done)
} | ${JAVA_HOME}/bin/java -classpath "\$(find ${cwsw}/nashorn/current/lib/ -type f | grep jar\$ | paste -s -d: -)" org.openjdk.nashorn.tools.Shell -scripting - 2>/dev/null
EOF
  chmod 755 env.nashorn
fi

# env.rhino - rhino js on java jvm
: ${JAVA_HOME:=""}
if [ ! -z "${JAVA_HOME}" ] ; then
  scriptecho "installing ${cgidir}/env.rhino"
  cat >env.rhino<<EOF
#!/usr/bin/env bash
export _JAVA_OPTIONS='-Djava.io.tmpdir=/usr/local/crosware/tmp -Djava.awt.headless=true -XX:-UsePerfData'
${JAVA_HOME}/bin/java -jar "/usr/local/crosware/software/rhino/current/rhino.jar" -e '
$(for k in ${!jvmjs[@]} ; do printf '%s\n' "${jvmjs[${k}]}" ; done)
' 2>/dev/null
EOF
  chmod 755 env.rhino
fi

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
