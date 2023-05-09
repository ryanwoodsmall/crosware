rname="global"
rver="6.6.10"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="2dd1e6a945e93c01390fb941a4e694f4c71bbd7569d64149c04e927bbf4dcce8"
rreqs="make ncurses sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" >/dev/null 2>&1
  sed -i.ORIG 's/-lcurses/-lncurses/g;s/makeinfo/true/g' configure
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
