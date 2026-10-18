rname="lmin"
rver="1.00"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.acme.com/software/lmin/${rfile}"
rsha256="4e0496279c3196af59c6d389e451c3e234a18d951debcc7ea3f09448a1ee3641"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  grep -ril 'printf.*>' . | xargs sed -i '/printf.*>/s,^,{,g'
  grep -ril 'printf.*>' . | xargs sed -i '/printf.*>/s,$,fflush(stdout);fflush(stderr);},g'
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat Makefile > Makefile.ORIG
  sed -i \"s,/usr/local,\$(cwidir_${rname}),g\" Makefile
  sed -i '/^#NO_LEAKFINDER/s,^#,,g' Makefile
  sed -i '/^CFLAGS/s/$/ -Wl,-static/g' Makefile
  sed -i '/^LDFLAGS/s/$/ -static/g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cwmkdir \"\$(cwidir_${rname})\"
  rm -rf \$(cwidir_${rname})/examples
  make install
  cwmkdir \"\$(cwidir_${rname})/examples\"
  ( cd examples ; tar -cf - . ) | ( cd \"\$(cwidir_${rname})/examples\" ; tar -xf - )
  echo '#!/usr/bin/env bash' > \"\$(cwidir_${rname})/bin/${rname}.rlwrap\"
  echo 'rlwrap -C ${rname} -pBlue -m -q\\\" \"${rtdir}/current/bin/${rname}\" \"\${@}\"' >> \"\$(cwidir_${rname})/bin/${rname}.rlwrap\"
  chmod 0755 \"\$(cwidir_${rname})/bin/${rname}.rlwrap\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
