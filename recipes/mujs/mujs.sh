rname="mujs"
rver="1.3.2"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ccxvii/${rname}/archive/${rfile}"
rsha256="59763cc32776714b4f00a0efede83f4f56b381c9dbaced4756d665c214249dca"
rreqs="make netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's/-lreadline/-lreadline -lcurses -lterminfo -static/g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make release \
    prefix=\"\$(cwidir_${rname})\" \
    CC=\"\${CC} \${CFLAGS} \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=-static \
    CPPFLAGS=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install \
    prefix=\"\$(cwidir_${rname})\" \
    CC=\"\${CC} \${CFLAGS} \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=-static \
    CPPFLAGS=
  install -m 755 \"build/release/${rname}-pp\" \"\$(cwidir_${rname})/bin/${rname}-pp\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}-pp\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
