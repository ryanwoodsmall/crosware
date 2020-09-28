rname="cscope"
rver="15.8b"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="http://prdownloads.sourceforge.net/${rname}/${rfile}"
rsha256="4889d091f05aa0845384b1e4965aa31d2b20911fb2c001b2cdcffbcb7212d3af"
rreqs="make ncurses bison flex configgit"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG 's/-lcurses/-lncurses/g' configure
  ./configure ${cwconfigureprefix}
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
