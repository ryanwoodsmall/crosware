rname="es"
rver="0.9.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/wryun/es-shell/releases/download/v${rver}/${rfile}"
rsha256="c926482b42084e903eb871ee1eb0cefc09dae6f1adeb8408dd9e933035c4f5dd"
rreqs="make byacc netbsdcurses"

. "${cwrecipe}/common.sh"

eval "
function cwextract_${rname}() {
  cwmkdir \"\$(cwbdir_${rname})\"
  cwextract \"\$(cwdlfile_${rname})\" \"\$(cwbdir_${rname})\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/netbsdcurses/current/lib/pkgconfig\" \
    YACC=\"${cwsw}/byacc/current/bin/byacc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
