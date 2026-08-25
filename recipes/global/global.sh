rname="global"
rver="6.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="fdab590c9bda2d68d55e99c51c7e60c2c8595ae4dcebab9bbbb0795f2a5c8bf7"
rreqs="make ncurses sed slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG 's/-lcurses/-lncurses/g;s/makeinfo/true/g' configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} ${rlibtool}
  sed -i.ORIG s,-shared,,g plugin-factory/Makefile
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
