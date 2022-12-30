#
# XXX - look at alpine: https://git.alpinelinux.org/aports/tree/main/sqlite/APKBUILD
# XXX - and at ALL the options... https://sqlite.org/compile.html
#

rname="sqlite"
rver="3400100"
rdir="${rname}-autoconf-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.sqlite.org/2022/${rfile}"
rsha256="2c5dea207fa508d765af1ef620b637dcb06572afa6f01f0815bd5bbf864b33d9"
rreqs="make netbsdcurses readlinenetbsdcurses zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG s/termcap/terminfo/g configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-readline \
    CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static\" \
    LIBS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -lreadline -lcurses -lterminfo -lz -static\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
}
"
