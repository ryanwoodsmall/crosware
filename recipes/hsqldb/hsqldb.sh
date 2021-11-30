rname="hsqldb"
rver="2.6.1"
rvermaj="${rver%%.*}"
rvermin="${rver#*.}"
rvermin="${rvermin%.*}"
rdir="${rname}-${rver}"
rfile="${rdir}.zip"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rname}_${rvermaj}_${rvermin}/${rfile}/download"
rsha256="722c721308c4b7af143a8b5dd53709372554c53443c785f27f2620f64ea446d4"
rreqs=""

unset rvermaj rvermin

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  cwscriptecho \"extracting ${rdlfile}\"
  cwextract \"${rdlfile}\" \"${cwbuild}\" >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cd \"${rname}\"
  chmod 644 bin/*.bat
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  true
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local hsqldbserver=\"${ridir}/bin/${rname}-server.sh\"
  local hsqldbwebserver=\"${ridir}/bin/${rname}-webserver.sh\"
  local hsqldbshell=\"${ridir}/bin/${rname}-sqltool.sh\"
  cd \"${rname}\"
  cwmkdir \"${ridir}\"
  tar -cf - . | ( cd \"${ridir}\" ; tar -xf - )
  rm -rf \"${ridir}/jar\"
  cwmkdir \"${ridir}/jar\"
  ln -sf \"${rtdir}/current/lib/sqltool.jar\" \"${ridir}/jar/\"
  ln -sf \"${rtdir}/current/lib/${rname}.jar\" \"${ridir}/jar/\"
  ln -sf \"${rtdir}/current/lib/${rname}-jdk8.jar\" \"${ridir}/jar/\"
  echo -n | tee \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo '#!/usr/bin/env bash' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo ': \${CLASSPATH:=\"\"}' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo 'export CLASSPATH=\"${rtdir}/current/jar/${rname}.jar:\${CLASSPATH}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo 'cd \"${cwtmp}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo 'java org.${rname}.server.Server \"\${@}\"' >> \"\${hsqldbserver}\"
  echo 'java org.${rname}.server.WebServer \"\${@}\"' >> \"\${hsqldbwebserver}\"
  echo 'java -jar \"${rtdir}/current/jar/sqltool.jar\" \"\${@}\"' >> \"\${hsqldbshell}\"
  chmod 755 \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\"
  unset hsqldbserver hsqldbshell

  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
