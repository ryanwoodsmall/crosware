#
# XXX - look at alpine: https://git.alpinelinux.org/aports/tree/main/sqlite/APKBUILD
# XXX - and at ALL the options... https://sqlite.org/compile.html
#

rname="sqlite"
rver="3380300"
rdir="${rname}-autoconf-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.sqlite.org/2022/${rfile}"
rsha256="61f2dd93a2e38c33468b7125967c3218bf9f4dd8365def6025e314f905dc942e"
rreqs="make netbsdcurses zlib"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG s/termcap/terminfo/g configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} --enable-readline \
    CPPFLAGS=\"-I${cwsw}/netbsdcurses/current/include -I${cwsw}/zlib/current/include\" \
    LDFLAGS=\"-L${cwsw}/netbsdcurses/current/lib -L${cwsw}/zlib/current/lib -static\" \
    LIBS=\"-L${cwsw}/netbsdcurses/current/lib -lreadline -lcurses -lterminfo -L${cwsw}/zlib/current/lib -lz\"
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
