#
# XXX - cli supports editline/libedit (default), readline, and linenoise
# XXX - linenoise has no external deps...
# XXX - editline needs editline/history.h, netbsdcurses can be coaxed:
#   eval "
#   function cwpatch_${rname}() {
#     pushd \"${rbdir}\" &>/dev/null
#     mkdir -p include/editline
#     ln -sf \"${cwsw}/netbsdcurses/current/include/editline/readline.h\" include/editline/
#     ln -sf readline.h include/editline/history.h
#     popd &>/dev/null
#   }
#   "
#

rname="nftables"
rver="1.1.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="6358830f3a64f31e39b0ad421d7dadcd240b72343ded48d8ef13b8faf204865a"
rreqs="bootstrapmake pkgconfig byacc netbsdcurses readlinenetbsdcurses libpcap libnl jansson libmnl libnetfilterconntrack libnfnetlink libnftnl iptables slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --with-json --with-mini-gmp --with-xtables --disable-man-doc --disable-python --without-python-bin --with-cli=readline \
      CPPFLAGS=\"-I\$(cwbdir_${rname})/include \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lreadline -lcurses -lterminfo -static' \
      YACC=\"${cwsw}/byacc/current/bin/byacc\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
