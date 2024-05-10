#
# XXX - online-only, main jar is cached but poms/checksums/support jars are not
# XXX - dependency stuff will break if anything other than asm{,-*} is added!!!
# XXX - maven/gradle/... would be better here, but, sdkman? guh
#
rname="nashorn"
rver="15.4"
rdir="${rname}-${rver}"
rfile="${rname}-core-${rver}.jar"
rurl="https://repo1.maven.org/maven2/org/openjdk/nashorn/nashorn-core/${rver}/${rfile}"
rsha256="fake"
rreqs="libxml2 busybox"

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
  local pf=\$(cwdlfile_${rname} | sed 's/jar\$/pom/g')
  cwfetch \"\$(cwurl_${rname} | sed 's/jar\$/pom/g')\" \${pf}
  local av=\$(xmllint --xpath '/*[local-name()=\"project\"]/*[local-name()=\"dependencies\"]/*[local-name()=\"dependency\"]/*[local-name()=\"version\"]/text()' \${pf} | head -1)
  cwmkdir \$(cwidir_${rname})/lib
  local a=''
  for a in \$(xmllint --xpath '/*[local-name()=\"project\"]/*[local-name()=\"dependencies\"]/*[local-name()=\"dependency\"]/*[local-name()=\"artifactId\"]/text()' \${pf}) ; do
    cwscriptecho \"fetching \${a} version \${av}\"
    local f=''
    local u=''
    local m=''
    f=\$(cwdlfile_${rname} | xargs dirname)/\${a}-\${av}.jar
    u=https://repo1.maven.org/maven2/org/ow2/asm/\${a}/\${av}/\$(basename \${f})
    cwfetch \${u} \${f}
    m=\$(curl \${cwcurlopts} \${u}.md5)
    md5sum \${f} | grep -q \${m}
    install -m 644 \${f} \$(cwidir_${rname})/lib/\$(basename \${f})
    : ln -sf \$(basename \${f}) \$(cwidir_${rname})/lib/\${a}.jar
  done
  unset pf av a f u m
}
"

eval "
function cwmakeinstall_${rname}() {
  cwmkdir \$(cwidir_${rname})/bin
  cwmkdir \$(cwidir_${rname})/lib
  install -m 644 \$(cwdlfile_${rname}) \$(cwidir_${rname})/lib/
  : ln -sf \$(cwfile_${rname}) \$(cwidir_${rname})/lib/${rname}.jar
  local b=\$(cwidir_${rname})/bin/${rname}
  echo -n > \${b}
  echo '#!/usr/bin/env bash' >> \${b}
  echo 'java -classpath \$(find ${rtdir}/current/lib/ -type f | grep jar\$ | paste -s -d: -) org.openjdk.nashorn.tools.Shell \"\${@}\"' >> \${b}
  chmod 755 \${b}
  unset b
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
