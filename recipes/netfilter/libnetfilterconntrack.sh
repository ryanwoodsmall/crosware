rname="libnetfilterconntrack"
rver="1.0.8"
rdir="${rname//rc/r_c}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname//rc/r_c}/${rfile}"
rsha256="0cd13be008923528687af6c6b860f35392d49251c04ee0648282d36b1faec1cf"
rreqs="bootstrapmake pkgconfig libmnl libnfnetlink"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\"
  popd >/dev/null 2>&1
}
"
