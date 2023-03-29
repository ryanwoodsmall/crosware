rname="most"
rver="5.2.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.jedsoft.org/releases/${rname}/${rfile}"
rsha256="9455aeb8f826fa8385c850dc22bf0f22cf9069b3c3423fba4bf2c6f6226d9903"
rreqs="make slang configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
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
