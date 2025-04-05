rname="m4"
rver="1.4.19"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.bz2"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="b306a91c0fd93bc4280cfc2e98cb7ab3981ff75a187bea3293811f452c89a8c8"
rreqs="make sed"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} LDFLAGS=-static CPPFLAGS= PKG_CONFIG_{LIBDIR,PATH}=
  cat lib/sigsegv.c > lib/sigsegv.c.ORIG
  echo '#include <config.h>' > lib/sigsegv.c
  echo '#include <sys/reg.h>' >> lib/sigsegv.c
  sed '/<config/d' lib/sigsegv.c.ORIG >> lib/sigsegv.c
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
