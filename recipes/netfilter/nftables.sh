#
# XXX - json support requires jansson
#

rname="nftables"
rver="1.0.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="58bf547daf967a2b88ecb4f425f126006ebde22711db806b25c1d6cf84fe45f4"
rreqs="bootstrapmake pkgconfig byacc netbsdcurses libpcap libnl libmnl libnetfilterconntrack libnfnetlink libnftnl iptables"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --with-mini-gmp --with-xtables --disable-man-doc --disable-python --without-json --without-python-bin \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lreadline -lcurses -lterminfo -static'
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
