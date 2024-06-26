rname="mujs"
rver="1.3.5"
rdir="${rname}-${rver}"
rfile="${rver}.tar.gz"
rurl="https://github.com/ccxvii/${rname}/archive/${rfile}"
rsha256="78a311ae4224400774cb09ef5baa2633c26971513f8b931d3224a0eb85b13e0b"
rreqs="make netbsdcurses readlinenetbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's/-lreadline/-lreadline -lcurses -lterminfo -static/g' Makefile
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make release \
    prefix=\"\$(cwidir_${rname})\" \
    CC=\"\${CC} \${CFLAGS} \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=-static \
    CPPFLAGS=
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install \
    prefix=\"\$(cwidir_${rname})\" \
    CC=\"\${CC} \${CFLAGS} \$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=-static \
    CPPFLAGS=
  install -m 755 \"build/release/${rname}-pp\" \"\$(cwidir_${rname})/bin/${rname}-pp\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}\"
  \$(\${CC} -dumpmachine)-strip --strip-all \"\$(cwidir_${rname})/bin/${rname}-pp\"
  cwmkdir \"\$(cwidir_${rname})/docs\"
  ( cd docs/ ; tar -cf - . ) | ( cd \"\$(cwidir_${rname})/docs\" ; tar -xf - )
  popd &>/dev/null
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
