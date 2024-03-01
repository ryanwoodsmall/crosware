rname="cscope"
rver="15.9"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://prdownloads.sourceforge.net/${rname}/${rfile}"
rsha256="c5505ae075a871a9cd8d9801859b0ff1c09782075df281c72c23e72115d9f159"
rreqs="make ncurses bison flex configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's/-lcurses/-lncurses/g' configure
  ./configure ${cwconfigureprefix}
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
