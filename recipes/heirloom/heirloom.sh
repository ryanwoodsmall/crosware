#
# XXX - build
#   - can build with byacc, maybe a better/smaller choice than bison?
#   - netbsdcurses works: set proper -I and -L, add '-DTPARM_VARARGS -DUSE_TERMCAP' to CPPFLAGS, set LCURS to '-lcurses -lterminfo'
#   - 9base provides yacc and ed and they seem to work
#
# XXX - profile ordering
#   - use zz_00_heirloom.sh to come before 9base?
#
rname="heirloom"
rver="20180802-musl"
rdir="${rname}-project-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ryanwoodsmall/${rname}-project/archive/${rfile}"
rsha256="4434595f93b8fe34cb2f52ddb9fb6b69119c06a76c57cb829727e0418ccce353"
rreqs="make sed ncurses zlib bzip2 flex bison ed"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  grep -ril \"/usr/local/${rname}\" . \
  | xargs sed -i \"s#/usr/local/${rname}#${ridir}#g\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local d=''
  for d in '' -{sh,devtools,doctools} ; do
    pushd ${rname}\${d}
    make
    make install
    popd
  done
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  cwscriptecho \"cwmakeinstall_${rname} noop\"
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/5bin/posix2001\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/5bin/posix\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/ucb\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/ccs/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/5bin/s42\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/5bin/sv3\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
