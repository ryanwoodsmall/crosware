#
# XXX - dynamic???
#

rname="conntracktools"
rver="1.4.7"
rdir="${rname//kt/k-t}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname//kt/k-t}/${rfile}"
rsha256="099debcf57e81690ced57f516b493588a73518f48c14d656f823b29b4fc24b5d"
rreqs="bootstrapmake pkgconfig byacc flex slibtool libtirpc libmnl libnfnetlink libnetfilterconntrack libnetfiltercttimeout libnetfiltercthelper libnetfilterqueue"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
    LIBS='-lmnl -static'
  grep -ril -- -lnetfilter_cttimeout . | grep /Makefile | xargs sed -i 's,-lnetfilter_cttimeout,-lnetfilter_cttimeout -lmnl,g'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
