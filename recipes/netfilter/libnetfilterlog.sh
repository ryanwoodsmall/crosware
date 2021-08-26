rname="libnetfilterlog"
rver="1.0.1"
rdir="${rname//rl/r_l}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname//rl/r_l}/${rfile}"
rsha256="74e0fe75753dba3ac114531b5e73240452c789a3f3adccf5c51217da1d933b21"
rreqs="bootstrapmake configgit pkgconfig libnfnetlink"

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
