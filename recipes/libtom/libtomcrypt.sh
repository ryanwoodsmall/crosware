rname="libtomcrypt"
rver="1.18.2"
rdir="${rname}-${rver}"
rfile="crypt-${rver}.tar.xz"
rurl="https://github.com/libtom/${rname}/releases/download/v${rver}/${rfile}"
rsha256="96ad4c3b8336050993c5bc2cf6c057484f2b0f9f763448151567fbab5e767b84"
rreqs="bootstrapmake libtommath"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  true
}
"

eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  pcf=\"${rname}.pc\"
  cat \"\${pcf}.in\" > \"\${pcf}\"
  sed -i '/^prefix=/s,@to-be-replaced@,${rtdir}/current,g' \"\${pcf}\"
  sed -i '/^Version:/s,@to-be-replaced@,${rver},g' \"\${pcf}\"
  unset pcf
  popd >/dev/null 2>&1
}
"

eval "
function cwmake_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make -j${cwmakejobs} \
    PREFIX=\"${ridir}\" \
    CC=\"\${CC}\" \
    CFLAGS=\"\${CFLAGS} -DUSE_LTM -DLTM_DESC -I${cwsw}/libtommath/current/include\" \
    EXTRALIBS=\"-L${cwsw}/libtommath/current/lib -ltommath -static\" \
      all
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  rm -f \"${ridir}/bin/${rname}-hashsum\"
  rm -f \"${ridir}/bin/hashsum\"
  for t in install_all hashsum ltcrypt sizes constants openssl-enc ; do
    make \
      PREFIX=\"${ridir}\" \
      CC=\"\${CC}\" \
      CFLAGS=\"\${CFLAGS} -DUSE_LTM -DLTM_DESC -I${cwsw}/libtommath/current/include\" \
      EXTRALIBS=\"-L${cwsw}/libtommath/current/lib -ltommath -static\" \
        \${t}
    if [[ ! \${t} =~ install_all ]] ; then
      \$(\${CC} -dumpmachine)-strip --strip-all \${t}
      install -m 755 \${t} \"${ridir}/bin/${rname}-\${t}\"
    fi
  done
  ln -sf \"${rname}-hashsum\" \"${ridir}/bin/hashsum\"
  cwmkdir \"${ridir}/lib/pkgconfig\"
  install -m 644 \"${rname}.pc\" \"${ridir}/lib/pkgconfig/${rname}.pc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
