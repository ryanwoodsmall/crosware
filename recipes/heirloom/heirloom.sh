#
# XXX - profile ordering
#   - use zz_00_heirloom.sh to come before 9base?
#
# XXX - gcc 9 issues
#   - https://www.illumos.org/issues/11533
#   - https://github.com/illumos/illumos-gate/commit/356ba08c15b26adbde3440aa89d8b31cd39fc526
#
rname="heirloom"
rreqs="make sed netbsdcurses zlib bzip2 ed byacc reflex oksh busybox bashtiny"

. "${cwrecipe}/heirloom/heirloom.sh.common"
. "${cwrecipe}/common.sh"

eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  grep -ril /bin/bash . | xargs sed -i.ORIG \"s,/bin/bash,${cwsw}/bashtiny/current/bin/bash,g\"
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  grep -ril \"/usr/local/${rname}\" . \
  | xargs sed -i \"s#/usr/local/${rname}#\$(cwidir_${rname})#g\"
  sed -i '/^LEX = /s/LEX.*/LEX=reflex/g' heirloom/build/mk.config
  sed -i '/^YACC = /s/YACC.*/YACC=byacc/g' heirloom/build/mk.config
  sed -i '/^LCURS = /s/LCURS.*/LCURS = -lcurses -lterminfo/g' heirloom/build/mk.config
  sed -i '/^CPPFLAGS/s/$/ -DTPARM_VARARGS -DUSE_TERMCAP/g' heirloom/build/mk.config
  sed -i 's#/ncurses#/netbsdcurses#g' heirloom/build/mk.config
  sed -i 's#/ncurses/#/netbsdcurses/#g' heirloom-ex-vi/Makefile
  sed -i '/^TERMLIB/s/ncurses/curses/g' heirloom-ex-vi/Makefile
  sed -i '/^#LDADD/s/.*/LDADD = -lcurses -lterminfo/g' heirloom-ex-vi/Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  local d=''
  for d in ${rname}{,-{sh,devtools,doctools,ex-vi}} ; do
    pushd \${d}
    env CHARSET= PATH=\"${cwsw}/byacc/current/bin:${cwsw}/reflex/current/bin:${cwsw}/oksh/current/bin:\${PATH}\" make
    env CHARSET= PATH=\"${cwsw}/byacc/current/bin:${cwsw}/reflex/current/bin:${cwsw}/oksh/current/bin:\${PATH}\" make install
    popd
  done
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  true
}
"

eval "
function cwgenprofd_${rname}() {
  rm -f \"${cwetcprofd}/${rname}.sh\"
  rm -f \"${cwetcprofd}/zz_${rname}.sh\"
  echo -n '' > \"${rprof}\"
  echo 'append_path \"${cwsw}/bison/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/byacc/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/flex/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/reflex/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/make/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${cwsw}/bootstrapmake/current/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/5bin/posix2001\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/5bin/posix\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/ucb\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/ccs/bin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/5bin/s42\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/5bin/sv3\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
}
"
