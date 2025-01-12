#
# XXX - online-only, main jar is cached but poms/checksums/support jars are not
# XXX - dependency stuff will break if anything other than asm{,-*} is added!!!
# XXX - maven/gradle/... would be better here, but, sdkman? guh
# XXX - replace rlwrap with jline?
#
rname="nashorn"
rver="15.6"
rdir="${rname}-${rver}"
rfile="${rname}-core-${rver}.jar"
rurl="https://repo1.maven.org/maven2/org/openjdk/nashorn/nashorn-core/${rver}/${rfile}"
rsha256="fake"
rreqs="busybox libxml2 rlwrap"

. "${cwrecipe}/common.sh"

cwstubfunc "cwclean_${rname}"
cwstubfunc "cwextract_${rname}"
cwstubfunc "cwconfigure_${rname}"
cwstubfunc "cwmake_${rname}"

eval "
function cwsha256_${rname}() {
  cwfetch \"\$(cwurl_${rname}).sha256\" \"\$(cwdlfile_${rname}).sha256\" &>/dev/null
  cat \"\$(cwdlfile_${rname}).sha256\" | dos2unix | xargs echo -n | awk '{print \$1}'
}
"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  local xl=${cwsw}/libxml2/current/bin/xmllint
  local pf=\$(cwdlfile_${rname} | sed 's/jar\$/pom/g')
  cwfetch \"\$(cwurl_${rname} | sed 's/jar\$/pom/g')\" \${pf}
  local av=\$(\${xl} --xpath '/*[local-name()=\"project\"]/*[local-name()=\"dependencies\"]/*[local-name()=\"dependency\"]/*[local-name()=\"version\"]/text()' \${pf} | head -1)
  cwmkdir \$(cwidir_${rname})/lib
  local a=''
  for a in \$(\${xl} --xpath '/*[local-name()=\"project\"]/*[local-name()=\"dependencies\"]/*[local-name()=\"dependency\"]/*[local-name()=\"artifactId\"]/text()' \${pf}) ; do
    local f=''
    local u=''
    local m=''
    f=\$(cwdlfile_${rname} | xargs dirname)/\${a}-\${av}.jar
    u=https://repo1.maven.org/maven2/org/ow2/asm/\${a}/\${av}/\$(basename \${f})
    cwfetch \${u} \${f}
    m=\$(curl \${cwcurlopts} \${u}.md5)
    md5sum \${f} | grep -q \${m}
    install -m 644 \${f} \$(cwidir_${rname})/lib/\$(basename \${f})
  done
  unset xl pf av a f u m
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \$(cwidir_${rname})/bin
  cwmkdir \$(cwidir_${rname})/lib
  install -m 644 \$(cwdlfile_${rname}) \$(cwidir_${rname})/lib/
  local b=\$(cwidir_${rname})/bin/${rname}
  echo -n > \${b}
  echo '#!/usr/bin/env bash' >> \${b}
  echo 'rlwrap -C ${rname} java -classpath \$(find ${rtdir}/current/lib/ -type f | grep jar\$ | paste -s -d: -) org.openjdk.nashorn.tools.Shell \"\${@}\"' >> \${b}
  chmod 755 \${b}
  unset b
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
