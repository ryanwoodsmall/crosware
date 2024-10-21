rname="libnetfilterconntrack"
rver="1.1.0"
rdir="${rname//rc/r_c}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.netfilter.org/pub/${rname//rc/r_c}/${rfile}"
rsha256="67edcb4eb826c2f8dc98af08dabff68f3b3d0fe6fb7d9d0ac1ee7ecce0fe694e"
rreqs="bootstrapmake pkgconfig libmnl libnfnetlink"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"
