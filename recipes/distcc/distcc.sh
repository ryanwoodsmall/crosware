#
# XXX - @file mode: libiberty, binutils
# XXX - pump mode: python3
# XXX - ${PATH}: ccache -> distcc -> statictoolchain
# XXX - compiler symlinks
#

rname="distcc"
rver="3.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/${rname}/${rname}/releases/download/v${rver}/${rfile}"
rsha256="2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d"
rreqs="bootstrapmake"
rprof="${cwetcprofd}/zz_${rname}.sh"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --disable-pump-mode \
    --disable-Werror \
    --enable-rfc2553 \
    --with-included-popt \
    --without-auth \
    --without-avahi \
    --without-gnome \
    --without-gtk \
    --without-libiberty \
      CPPFLAGS= \
      LDFLAGS=-static \
      PKG_CONFIG_LIBDIR= \
      PKG_CONFIG_PATH=
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local c
  make install ${rlibtool}
  cwmkdir \"${ridir}/lib/${rname}/bin\"
  realpath ${ridir}/bin/* | sort -u | xargs \$(\${CC} -dumpmachine)-strip --strip-all || true
  for c in {,{musl,\$(\${CC} -dumpmachine)}-}{{,g}cc,{g,c}++,cpp} ; do
    #ln -sf ${rname} \"${ridir}/bin/\${c}\"
    ln -sf \"${rtdir}/current/bin/${rname}\" \"${ridir}/lib/${rname}/bin/\${c}\"
  done
  unset c
  popd >/dev/null 2>&1
}
"

#eval "
#function cwgenprofd_${rname}() {
#  rm -f \"${cwetcprofd}/${rname}.sh\" \"${rprof}\" || true
#  echo 'prepend_path \"${cwsw}/statictoolchain/current/bin\"' > \"${rprof}\"
#  echo 'prepend_path \"${rtdir}/current/bin\"' >> \"${rprof}\"
#  echo 'prepend_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
#  echo 'prepend_path \"${rtdir}/current/lib/${rname}/bin\"' >> \"${rprof}\"
#  echo 'prepend_path \"${cwsw}/ccache/current/bin\"' >> \"${rprof}\"
#}
#"
