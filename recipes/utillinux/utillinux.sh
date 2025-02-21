#
# XXX - terminfo (netbsdcurses), slang (termcap?), etc. - replace ncurses?
# XXX - col was deprecated in 2.40; ugh. screw it just use heirloom when/if this break
# XXX - autoconf/automake/libtool/bison/flex necessary to regenerate from configure.ac; but, perl
#
rname="utillinux"
rver="2.40.4"
rdir="util-linux-${rver}"
rfile="${rdir}.tar.gz"
rsha256="5b3b1435c02ba201ebaa5066bb391965a614b61721155dfb7f7b6569e95b0627"
rreqs="make zlib ncurses readline gettexttiny slibtool pcre2 pkgconfig sqlite"

rburl="https://kernel.org/pub/linux/utils/util-linux"
grep -q '.*\..*\..*' <<< "${rver}" && rsver="${rver%.*}" || rsver="${rver}"
rurl="${rburl}/v${rsver}/${rfile}"
unset rburl rsver

. "${cwrecipe}/common.sh"

# XXX - something with 2.35.1 to 2.35.2 broke SYS_pidfd_... checks/definitions
# XXX - ugh
# sed -i.ORIG '/MANPAGES.*raw\.8/d' disk-utils/Makemodule.am
# touch -d 1970-01-01 disk-utils/Makemodule.am
# XXX - touchy stuff here, eliminate???
eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  cat include/pidfd-utils.h > include/pidfd-utils.h.ORIG
  echo '#include <sys/types.h>' > include/pidfd-utils.h
  cat include/pidfd-utils.h.ORIG >> include/pidfd-utils.h
  sed -i '/defined.*__linux/s/$/ \\&\\& defined(SYS_pidfd_send_signal)/g' include/pidfd-utils.h
  cat configure > configure.ORIG
  sed -i '/READLINE_LIBS/ s/-lreadline/-lreadline -lncurses -lncursesw/g' configure
  sed -i s,ul_haveprogram_col=no,ul_haveprogram_col=yes,g configure
  sed -i.ORIG 's/raw\.8/mkfs.8/g' Makefile.in
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env PATH=\"${cwsw}/ncurses/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --disable-asciidoc \
      --disable-makeinstall-chown \
      --disable-makeinstall-setuid \
      --disable-nls \
      --disable-pam-lastlog2 \
      --disable-pylibmount \
      --enable-line \
      --enable-pg \
      --enable-write \
      --with-readline \
      --without-cap-ng \
      --without-python \
      --without-selinux \
      --without-smack \
      --without-systemd \
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lreadline -lncurses -lncursesw' \
        LIBTOOL=\"${cwsw}/slibtool/current/bin/slibtool-static -all-static\" \
        PCRE2_POSIX_LIBS=\"\$(pkg-config --libs libpcre2-posix libpcre2-8)\" \
        build_col=yes \
        ul_haveprogram_col=yes
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
