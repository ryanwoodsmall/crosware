#
# XXX - dynamic support for modules?
# XXX - ugly workarounds for ethhdr, u_int16_t
# XXX - see: https://patchwork.ozlabs.org/project/openwrt/patch/1434902002-18745-1-git-send-email-amery@geeks.cl/
#
# XXX - breakage w/slibtool as of 1.8.9
#   /usr/local/crosware/software/statictoolchain/202109250959-x86_64-linux-musl/bin/../lib/gcc/x86_64-linux-musl/9.4.0/../../../../x86_64-linux-musl/bin/ld: /usr/local/crosware/software/libnftnl/current/lib/libnftnl.a(utils.o): in function `__abi_breakage':
#   utils.c:(.text+0x820): multiple definition of `__abi_breakage'; /usr/local/crosware/software/libnetfilterconntrack/current/lib/libnetfilter_conntrack.a(main.o):main.c:(.text+0x2dd): first defined here
#   collect2: error: ld returned 1 exit status
#   slibtool-static: exec error upon slbt_exec_link_create_executable(), line 1580: (see child process error messages).
#   slibtool-static: < returned to > slbt_exec_link(), line 1845.
#   make[3]: *** [Makefile:662: xtables-nft-multi] Error 2
#

rname="iptables"
rver="1.8.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.netfilter.org/pub/${rname}/${rfile}"
rsha256="5cc255c189356e317d070755ce9371eb63a1b783c34498fb8c30264f3cc59c9c"
rreqs="bootstrapmake pkgconfig libpcap libnl libmnl libnetfilterconntrack libnfnetlink libnftnl"

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
