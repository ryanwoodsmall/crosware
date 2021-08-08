rname="h2"
rver="1.4.200"
rdir="${rname}-${rver}"
rbdir="${cwbuild}/${rname}"
rfile="${rname}-2019-10-14.zip"
rurl="https://h2database.com/${rfile}"
rsha256="a72f319f1b5347a6ee9eba42718e69e2ae41e2f846b3475f9292f1e3beb59b01"
rreqs=""

. "${cwrecipe}/common.sh"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwextract_${rname}() {
  cwscriptecho \"extracting ${rdlfile}\"
  cwextract \"${rdlfile}\" \"${cwbuild}\" >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  chmod 644 bin/*
  chmod 755 bin/${rname}.sh
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
  local h2server=\"${ridir}/bin/${rname}-server.sh\"
  local h2shell=\"${ridir}/bin/${rname}-shell.sh\"
  cwmkdir \"${ridir}\"
  tar -cf - . | ( cd \"${ridir}\" ; tar -xf - )
  rm -rf \"${ridir}/jar\"
  cwmkdir \"${ridir}/jar\"
  ln -sf \"${rtdir}/current/bin/${rname}-${rver}.jar\" \"${ridir}/jar/${rname}.jar\"
  ln -sf \"${rtdir}/current/service/wrapper.jar\" \"${ridir}/jar/wrapper.jar\"
  echo -n | tee \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
  echo '#!/usr/bin/env bash' | tee -a \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
  echo ': \${CLASSPATH:=\"\"}' | tee -a \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
  echo 'export CLASSPATH=\"${rtdir}/current/jar/${rname}.jar:\${CLASSPATH}\"' | tee -a \"\${h2server}\" \"\${h2shell}\" >/dev/null 2>&1
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
