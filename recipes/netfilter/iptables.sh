#
# XXX - dynamic support for modules?
# XXX - ugly workarounds for ethhdr, u_int16_t
# XXX - see: https://patchwork.ozlabs.org/project/openwrt/patch/1434902002-18745-1-git-send-email-amery@geeks.cl/
#

rname="iptables"
rver="1.8.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="71c75889dc710676631553eb1511da0177bbaaf1b551265b912d236c3f51859f"
rreqs="bootstrapmake pkgconfig libpcap libnl libmnl libnetfilterconntrack libnfnetlink libnftnl slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rconfigureopts} ${rcommonopts} \
    --enable-bpf-compiler --enable-nfsynproxy --enable-libipq \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      PKG_CONFIG_LIBDIR=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      PKG_CONFIG_PATH=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
      LIBS='-lpcap -lnl-3 -lnl-genl-3 -lmnl -static'
  echo '#include <sys/types.h>' >> config.h
  echo '#include <netinet/if_ether.h>' >> config.h
  cat iptables/xshared.h > iptables/xshared.h.ORIG
  echo -n > iptables/xshared.h
  echo '#include <sys/types.h>' >> iptables/xshared.h
  echo '#include <netinet/if_ether.h>' >> iptables/xshared.h
  cat iptables/xshared.h.ORIG >> iptables/xshared.h
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
