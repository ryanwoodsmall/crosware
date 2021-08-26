rname="libnetfilterqueue"
rver="1.0.5"
rdir="${rname//rq/r_q}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname//rq/r_q}/${rfile}"
rsha256="f9ff3c11305d6e03d81405957bdc11aea18e0d315c3e3f48da53a24ba251b9f5"
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
