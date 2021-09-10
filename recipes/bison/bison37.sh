rname="bison37"
rver="3.7.6"
rdir="${rname%37}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname%37}/${rfile}"
rsha256="67d68ce1e22192050525643fc0a7a22297576682bef6a5c51446903f5aeef3cf"
rreqs="make m4 flex perl sed gawk"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} --disable-nls
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf \"${rname%37}\" \"${ridir}/bin/${rname}\"
  ln -sf \"${rname%37}\" \"${ridir}/bin/${rname%37}-${rver%.?}\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/${rname%37}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${cwsw}/${rname%37}/current/lib\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
}
"
