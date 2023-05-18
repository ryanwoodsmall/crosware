#
# XXX - something like this should work for figuring url...
#  echo "${rver}" | grep -q '.*\..*\..*' && sver="${rver%.?}" || sver="${rver}"
# XXX - terminfo (netbsdcurses), slang (termcap?), etc. - replace ncurses?
#
rname="utillinux"
rver="2.39"
rdir="util-linux-${rver}"
rfile="${rdir}.tar.xz"
rsha256="32b30a336cda903182ed61feb3e9b908b762a5e66fe14e43efb88d37162075cb"
rreqs="make zlib ncurses readline gettexttiny slibtool pcre2 pkgconfig"

rburl="https://kernel.org/pub/linux/utils/util-linux"
#rurl="${rburl}/v${rver%.?}/${rfile}"
rurl="${rburl}/v${rver}/${rfile}"
unset rburl

. "${cwrecipe}/common.sh"

# XXX - something with 2.35.1 to 2.35.2 broke SYS_pidfd_... checks/definitions
# XXX - ugh
# sed -i.ORIG '/MANPAGES.*raw\.8/d' disk-utils/Makemodule.am
# touch -d 1970-01-01 disk-utils/Makemodule.am
eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cat include/pidfd-utils.h > include/pidfd-utils.h.ORIG
  echo '#include <sys/types.h>' > include/pidfd-utils.h
  cat include/pidfd-utils.h.ORIG >> include/pidfd-utils.h
  sed -i '/defined.*__linux/s/$/ \\&\\& defined(SYS_pidfd_send_signal)/g' include/pidfd-utils.h
  sed -i.ORIG '/READLINE_LIBS/ s/-lreadline/-lreadline -lncurses -lncursesw/g' configure
  sed -i.ORIG 's/raw\.8/mkfs.8/g' Makefile.in
  sed -i.ORIG /PER_LINUX_FDPIC/d sys-utils/setarch.c
  env PATH=\"${cwsw}/ncurses/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} ${cwconfigurelibopts} \
      --disable-asciidoc \
      --disable-makeinstall-chown \
      --disable-makeinstall-setuid \
      --disable-nls \
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
        PCRE2_POSIX_LIBS=\"\$(pkg-config --libs libpcre2-posix libpcre2-8)\"
  popd >/dev/null 2>&1
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
