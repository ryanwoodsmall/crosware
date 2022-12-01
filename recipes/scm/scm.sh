#
# XXX - dynamic, leave as-is for now
# XXX - probably decouple slib/have standalone slib recipe?
# XXX - posix/readline/curses/editline/lib/dump/regex/socket/... options?
# XXX - editline could replace rlwrap? not sure
# XXX - http://people.csail.mit.edu/jaffer/buildscm.html
#
rname="scm"
rver="5f3-3b7"
rbdir="${cwbuild}/${rname}"
rdir="${rname}-${rver}"
rfile="${rname}-${rver%-*}.zip"
rurl="http://groups.csail.mit.edu/mac/ftpdir/${rname}/${rfile}"
rsha256="27c944b871c319a820e0fb1698bccb27d929db197f9e44d9ad4650f52aa4bdcb"
rreqs="make texinfo"

if ! command -v rlwrap &>/dev/null ; then
  rreqs+=" rlwrap"
fi

. "${cwrecipe}/common.sh"

slibfile="slib-${rver#*-}.zip"
slibdlfile="${cwdl}/${rname}/${slibfile}"

eval "
function cwclean_${rname}() {
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rname}\"
  rm -rf \"slib\"
  popd >/dev/null 2>&1
}
"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \
    \"\$(dirname \$(cwurl_${rname}))/${slibfile}\" \
    \"${slibdlfile}\" \
    \"f5d5cdad335395a5a5aa37effe28aa8078b216ea39911f651929678f1ac228b6\"
}
"

eval "
function cwextract_${rname}() {
  cwextract \"\$(cwdlfile_${rname})\" \"${cwbuild}\"
  cwextract \"${slibdlfile}\" \"${cwbuild}\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
  pushd \"${cwbuild}/slib\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make scmlit
  make all
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${cwbuild}/slib\" >/dev/null 2>&1
  env PATH=\"${rbdir}:\${PATH}\" make install
  popd >/dev/null 2>&1
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  rm -f \"\$(cwidir_${rname})/bin/scm\"
  rm -f \"\$(cwidir_${rname})/bin/scm.bin\"
  make install
  mv \"\$(cwidir_${rname})/bin/${rname}\" \"\$(cwidir_${rname})/bin/${rname}.bin\"
  echo 'rlwrap -C ${rname} -pBlue -m -M .scm -q\\\" \"${rtdir}/current/bin/${rname}.bin\" \"\${@}\"' >> \"\$(cwidir_${rname})/bin/${rname}\"
  chmod 755 \"\$(cwidir_${rname})/bin/${rname}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset slibfile
unset slibdlfile
