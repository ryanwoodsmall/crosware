rname="slsc"
rver="pre0.3.0-2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.jedsoft.org/snapshots/${rfile}"
rsha256="4b62ac5bca6a224c25db6b5f6ae8063e3fc8c99803d5323b9bbe55764e816919"
rreqs="make slang byacc configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG s/termcap/ncurses/g configure
  sed -i s/ncurses5-config/ncurses6-config/g configure
  sed -i s/ncursesw5-config/ncursesw6-config/g configure
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --without-x \
    --with-slang=\"${cwsw}/slang/current\" \
      YACC=byacc
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
