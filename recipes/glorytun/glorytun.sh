rname="glorytun"
rver="0.3.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/angt/${rname}/releases/download/v${rver}/${rfile}"
rsha256="137d9c525a05bb605163df0465367d36e943715ca773ce43d5ea66f0597600a3"
rreqs="bootstrapmake libsodium pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/libsodium/current/include\" \
    LDFLAGS=\"-L${cwsw}/libsodium/current/lib -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/libsodium/current/lib/pkgconfig\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
