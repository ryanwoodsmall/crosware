rname="hsqldb"
rver="2.7.3"
rvermaj="${rver%%.*}"
rvermin="${rver#*.}"
rvermin="${rvermin%.*}"
rdir="${rname}-${rver}"
rfile="${rdir}.zip"
rurl="https://sourceforge.net/projects/hsqldb/files/hsqldb/${rname}_${rvermaj}_${rvermin}/${rfile}/download"
rsha256="d3edee859f7fc58237e108864a71733eff5613d92dc65508dfa335bc0c5b1e94"
rreqs=""

unset rvermaj rvermin

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwextract_${rname}() {
  cwscriptecho \"extracting ${rdlfile}\"
  cwextract \"${rdlfile}\" \"${cwbuild}\" &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cd \"${rname}\"
  chmod 644 bin/*.bat
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cd \"${rname}\"
  local hsqldbserver=\"\$(cwidir_${rname})/bin/${rname}-server.sh\"
  local hsqldbwebserver=\"\$(cwidir_${rname})/bin/${rname}-webserver.sh\"
  local hsqldbshell=\"\$(cwidir_${rname})/bin/${rname}-sqltool.sh\"
  cwmkdir \"\$(cwidir_${rname})\"
  tar -cf - . | ( cd \"\$(cwidir_${rname})\" ; tar -xf - )
  rm -rf \"\$(cwidir_${rname})/jar\"
  cwmkdir \"\$(cwidir_${rname})/jar\"
  ln -sf \"${rtdir}/current/lib/sqltool.jar\" \"\$(cwidir_${rname})/jar/\"
  ln -sf \"${rtdir}/current/lib/${rname}.jar\" \"\$(cwidir_${rname})/jar/\"
  {
    echo -n | tee \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\"
    echo '#!/usr/bin/env bash' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\"
    echo ': \${CLASSPATH:=\"\"}' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\"
    echo 'export CLASSPATH=\"${rtdir}/current/jar/${rname}.jar:\${CLASSPATH}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\"
    echo 'mkdir -p \"${cwtmp}/${rname}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbwebserver}\"
    echo 'cd \"${cwtmp}/${rname}\"' | tee -a \"\${hsqldbserver}\" \"\${hsqldbwebserver}\"
    echo 'echo \"# pwd: \${PWD}\" 1>&2' | tee -a \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\"
    echo 'java org.${rname}.server.Server \"\${@}\"' >> \"\${hsqldbserver}\"
    echo 'java org.${rname}.server.WebServer \"\${@}\"' >> \"\${hsqldbwebserver}\"
    echo 'java -jar \"${rtdir}/current/jar/sqltool.jar\" \"\${@}\"' >> \"\${hsqldbshell}\"
  } &>/dev/null
  chmod 755 \"\${hsqldbserver}\" \"\${hsqldbshell}\" \"\${hsqldbwebserver}\"
  unset hsqldbserver hsqldbshell
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
