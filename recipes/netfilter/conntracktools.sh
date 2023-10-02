#
# XXX - dynamic???
#
rname="conntracktools"
rver="1.4.8"
rdir="${rname//kt/k-t}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.netfilter.org/pub/${rname//kt/k-t}/${rfile}"
rsha256="067677f4c5f6564819e78ed3a9d4a8980935ea9273f3abb22a420ea30ab5ded6"
rreqs="bootstrapmake pkgconfig byacc flex slibtool libtirpc libmnl libnfnetlink libnetfilterconntrack libnetfiltercttimeout libnetfiltercthelper libnetfilterqueue"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
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
