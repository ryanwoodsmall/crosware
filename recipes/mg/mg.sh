#
# XXX - keyname() conflicts with ncurses. oy
#
rname="mg"
rver="4.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/mg/releases/download/v${rver}/${rfile}"
rsha256="5955f48138bd5fc3ac53945d610f4089446afc5eea99bfb5f0a01f079426907e"
rreqs="make ncurses"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/ncurses/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
      CPPFLAGS=\"-I${cwsw}/ncurses/current/include\" \
      LDFLAGS=\"-L${cwsw}/ncurses/current/lib -static\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"${cwsw}/ncurses/current/lib/pkgconfig\" \
      LIBS=-static
  grep -rl 'getkeyname.*(' . | grep -E '\\.(c|h)\$' | xargs sed -i.ORIG1 '/getkeyname.*(/s,getkeyname,local_get_key_name,g'
  grep -rl 'keyname.*(' .    | grep -E '\\.(c|h)\$' | xargs sed -i.ORIG2 '/keyname.*(/s,keyname,local_key_name,g'
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
