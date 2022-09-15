#
# XXX - cli supports editline/libedit (default), readline, and linenoise
# XXX - linenoise has no external deps...
# XXX - editline needs editline/history.h, netbsdcurses can be coaxed:
#   eval "
#   function cwpatch_${rname}() {
#     pushd \"${rbdir}\" >/dev/null 2>&1
#     mkdir -p include/editline
#     ln -sf \"${cwsw}/netbsdcurses/current/include/editline/readline.h\" include/editline/
#     ln -sf readline.h include/editline/history.h
#     popd >/dev/null 2>&1
#   }
#   "
#

rname="nftables"
rver="1.0.5"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="8d1b4b18393af43698d10baa25d2b9b6397969beecac7816c35dd0714e4de50a"
rreqs="bootstrapmake pkgconfig byacc netbsdcurses libpcap libnl jansson libmnl libnetfilterconntrack libnfnetlink libnftnl iptables slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --with-json --with-mini-gmp --with-xtables --disable-man-doc --disable-python --without-python-bin --with-cli=readline \
      CPPFLAGS=\"-I\$(cwbdir_${rname})/include \$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lreadline -lcurses -lterminfo -static' \
      YACC=\"${cwsw}/byacc/current/bin/byacc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
