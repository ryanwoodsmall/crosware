rname="hsqldb"
rver="2.7.2"
rvermaj="${rver%%.*}"
rvermin="${rver#*.}"
rvermin="${rvermin%.*}"
rdir="${rname}-${rver}"
rfile="${rdir}.zip"
rurl="https://sourceforge.net/projects/${rname}/files/${rname}/${rname}_${rvermaj}_${rvermin}/${rfile}/download"
rsha256="ffb359cbe66ba3179317b6afdb62cd274765333bd30167ce332a4b2d85975812"
rreqs=""

unset rvermaj rvermin

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwextract_${rname}() {
  cwscriptecho \"extracting ${rdlfile}\"
  cwextract \"${rdlfile}\" \"${cwbuild}\" >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cd \"${rname}\"
  chmod 644 bin/*.bat
  popd >/dev/null 2>&1
}
"



eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local hsqldbserver=\"\$(cwidir_${rname})/bin/${rname}-server.sh\"
  local hsqldbwebserver=\"\$(cwidir_${rname})/bin/${rname}-webserver.sh\"
  local hsqldbshell=\"\$(cwidir_${rname})/bin/${rname}-sqltool.sh\"
  cd \"${rname}\"
  cwmkdir \"\$(cwidir_${rname})\"
  tar -cf - . | ( cd \"\$(cwidir_${rname})\" ; tar -xf - )
  rm -rf \"\$(cwidir_${rname})/jar\"
  cwmkdir \"\$(cwidir_${rname})/jar\"
  ln -sf \"${rtdir}/current/lib/sqltool.jar\" \"\$(cwidir_${rname})/jar/\"
  ln -sf \"${rtdir}/current/lib/${rname}.jar\" \"\$(cwidir_${rname})/jar/\"
  echo -n | tee \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo '#!/usr/bin/env bash' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo ': \${CLASSPATH:=\"\"}' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo 'export CLASSPATH=\"${rtdir}/current/jar/${rname}.jar:\${CLASSPATH}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo 'mkdir -p \"${cwtmp}/${rname}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
  echo 'cd \"${cwtmp}/${rname}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbwebserver}\" >/dev/null 2>&1
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
