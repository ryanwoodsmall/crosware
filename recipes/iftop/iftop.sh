rname="iftop"
rver="0.17"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://www.ex-parrot.com/~pdw/${rname}/download/${rfile}"
rsha256="d032547c708307159ff5fd0df23ebd3cfa7799c31536fa0aea1820318a8e0eac"
rreqs="make ncurses libpcap19 autoconf automake libtool libnl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  autoreconf -fiv
  env PATH=\"${cwsw}/libpcap19/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -I${cwsw}/ncurses/current/include/ncurses\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
      PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS=\"\$(${cwsw}/libpcap19/current/bin/pcap-config --static --libs)\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > "${rprof}"
}
"
