#
# catch-all syslog
#   *.* /var/log/messages
# docker syslog container
#   docker run -d --restart always --name syslogd -p 514:514/udp syslogd -r -n --ipany -B 514 -f /path/to/syslog.conf
# docker host config daemon.json snippet
#   {
#     "log-driver": "syslog",
#     "log-opts": {
#       "syslog-address": "udp://1.2.3.4:514",
#       "syslog-facility": "daemon",
#       "mode": "non-blocking",
#       "tag": "hostname01:{{.Name}}"
#     }
#   }
#

rname="inetutils"
rver="2.4"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="1789d6b1b1a57dfe2a7ab7b533ee9f5dfd9cbf5b59bb1bb3c2612ed08d0f68b2"
rreqs="make sed netbsdcurses readlinenetbsdcurses configgit"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"\$(cwurl_${rname})\" \"\$(cwdlfile_${rname})\" \"\$(cwsha256_${rname})\"
  cwfetchcheck \"https://raw.githubusercontent.com/bminor/glibc/glibc-2.33/inet/protocols/talkd.h\" \"${cwdl}/${rname}/talkd.h\" \"d820ecf039d562d6c29325bf0c4839e2ce6d9f9ad8773bd243e656b5c8c48a38\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  cwmkdir \"\$(cwbdir_${rname})/include/protocols\"
  cwmkdir \"\$(cwbdir_${rname})/include/bits/types\"
  install -m 0644 \"${cwdl}/${rname}/talkd.h\" \"\$(cwbdir_${rname})/include/protocols/talkd.h\"
  echo 'struct osockaddr { unsigned short int sa_family; unsigned char sa_data[14]; };' > include/bits/types/struct_osockaddr.h
  sed -i.ORIG \"s/LIBTERMCAP=-lcurses/LIBTERMCAP='-lcurses -lterminfo'/g\" configure
  sed -i 's/-lcurses/-lreadline -lcurses -lterminfo/g' configure
  sed -i 's/-lterminfo -lterminfo/-lterminfo/g' configure
  sed -i \"s/ LIBREADLINE=\$/LIBREADLINE='-lreadline -lcurses -lterminfo'/g\" configure
  ./configure ${cwconfigureprefix} \
    --libexecdir=\"\$(cwidir_${rname})/sbin\" \
    --enable-ipv4 \
    --enable-ipv6 \
    --enable-servers \
    --enable-clients \
    --enable-talk \
    --enable-talkd \
    --disable-ncurses \
    --disable-rcp \
    --disable-rlogin \
    --disable-rsh \
    --disable-silent-rules \
    --without-idn \
    --with-libreadline-prefix=\"${cwsw}/readlinenetbsdcurses/current\" \
      CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include) -I\$(cwbdir_${rname})/include\" \
      LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
      LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -lreadline -lcurses -lterminfo\"
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  make install-strip
  find \$(cwidir_${rname})/bin/ \$(cwidir_${rname})/sbin/ | xargs chmod a+x
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
  echo 'append_path \"${rtdir}/current/sbin\"' >> "${rprof}"
}
"
