#
# XXX - dynamic, leave as-is for now
# XXX - probably decouple slib/have standalone slib recipe?
# XXX - posix/readline/curses/editline/lib/dump/regex/socket/... options?
# XXX - editline could replace rlwrap? not sure
# XXX - build script generator? http://people.csail.mit.edu/jaffer/buildscm.html
#
# more detailed installation in docs:
# - https://people.csail.mit.edu/jaffer/scm/Installing-SCM.html#Installing-SCM
#   - https://people.csail.mit.edu/jaffer/scm/GNU-configure-and-make.html#GNU-configure-and-make
#     - https://people.csail.mit.edu/jaffer/scm/Making-scmlit.html#Making-scmlit
#     - https://people.csail.mit.edu/jaffer/scm/Makefile-targets.html#Makefile-targets
#   - https://people.csail.mit.edu/jaffer/scm/Building-SCM.html#Building-SCM
#     - https://people.csail.mit.edu/jaffer/scm/Invoking-Build.html#Invoking-Build
#     - https://people.csail.mit.edu/jaffer/scm/Build-Options.html#Build-Options
#     - https://people.csail.mit.edu/jaffer/scm/Compiling-and-Linking-Custom-Files.html#Compiling-and-Linking-Custom-Files
#
rname="scm"
rver="5f4-3c1"
rbdir="${cwbuild}/${rname}"
rdir="${rname}-${rver}"
rfile="${rname}-${rver%-*}.zip"
rurl="http://groups.csail.mit.edu/mac/ftpdir/${rname}/${rfile}"
rsha256="d3426dff809d80b49bf2e9f7f3bab21183ef920323fc53f5ac58310137d4269e"
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
    \"c2f8eb98e60530df53211985d4b403b6e97a7a969833c1a6d1bf83561da0c781\"
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
