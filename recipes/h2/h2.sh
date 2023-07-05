#
# XXX - postgresql mode seems to work best with version 8.1 jdbc
# XXX - https://jdbc.postgresql.org/download/postgresql-8.1-415.jdbc3.jar
# XXX - example jdbc url below...
#
#  jdbc:postgresql://localhost:5435/~/tmppg;MODE=PostgreSQL;DATABASE_TO_LOWER=TRUE;DEFAULT_NULL_ORDERING=HIGH
#

rname="h2"
rver="2.2.220"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}"
rfile="${rname}-2023-07-04.zip"
#rurl="https://h2database.com/${rfile}"
rurl="https://github.com/h2database/h2database/releases/download/version-${rver}/${rfile}"
rsha256="f461dce80bc055c5ec7652c31249d7639a780e046e3974e45ee0ab79e7a36812"
rreqs=""

. "${cwrecipe}/common.sh"

cwstubfunc "cwmake_${rname}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwextract_${rname}() {
  cwscriptecho \"extracting \$(cwdlfile_${rname})\"
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\" >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  chmod 644 bin/*
  chmod 755 bin/${rname}.sh
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  local h2server=\"\$(cwidir_${rname})/bin/${rname}-server.sh\"
  local h2shell=\"\$(cwidir_${rname})/bin/${rname}-shell.sh\"
  cwmkdir \"\$(cwidir_${rname})\"
  tar -cf - . | ( cd \"\$(cwidir_${rname})\" ; tar -xf - )
  rm -rf \"\$(cwidir_${rname})/jar\"
  cwmkdir \"\$(cwidir_${rname})/jar\"
  ln -sf \"${rtdir}/current/bin/${rname}-\$(cwver_${rname}).jar\" \"\$(cwidir_${rname})/jar/${rname}.jar\"
  ln -sf \"${rtdir}/current/service/wrapper.jar\" \"\$(cwidir_${rname})/jar/wrapper.jar\"
  echo -n | tee \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
  echo '#!/usr/bin/env bash' | tee -a \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
  echo ': \${CLASSPATH:=\"\"}' | tee -a \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
  echo 'export CLASSPATH=\"${rtdir}/current/jar/${rname}.jar:\${CLASSPATH}\"' | tee -a \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
  echo 'mkdir -p \"${cwtmp}/${rname}\"' >> \"\${h2server}\"
  echo 'cd \"${cwtmp}/${rname}\"' >> \"\${h2server}\"
  echo 'java org.${rname}.tools.Server \$(echo -{web,tcp,pg}{,AllowOthers}) -ifNotExists \"\${@}\"' >> \"\${h2server}\"
  echo 'java org.${rname}.tools.Shell \"\${@}\"' >> \"\${h2shell}\"
  chmod 755 \"\${h2server}\" \"\${h2shell}\"
  unset h2server h2shell
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
