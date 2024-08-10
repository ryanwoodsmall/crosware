rname="libnftnl"
rver="1.2.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="9122774f968093d5c0bacddd67de480f31fa4073405a7fc058a34b0f387aecb3"
rreqs="bootstrapmake pkgconfig libmnl"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"
