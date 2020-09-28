rname="most"
rver="5.1.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.jedsoft.org/releases/${rname}/${rfile}"
rsha256="db805d1ffad3e85890802061ac8c90e3c89e25afb184a794e03715a3ed190501"
rreqs="make slang configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG s/ncurses5-config/ncurses6-config/g configure
  sed -i s/ncursesw5-config/ncursesw6-config/g configure
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    --without-x \
    --with-slang=\"${cwsw}/slang/current\"
  mkdir -p src/objs
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
