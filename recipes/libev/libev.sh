rname="libev"
rver="4.33"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
#rurl="http://dist.schmorp.de/${rname}/${rfile}"
#rurl="https://sources.voidlinux.org/${rdir}/${rfile}"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rsha256="507eb7b8d1015fbec5b935f34ebed15bf346bed04a11ab82b8eee848c4205aea"
rreqs="make slibtool"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" &>/dev/null
  make install ${rlibtool}
  cat \"${ridir}/include/event.h\" > \"${ridir}/include/${rname}_event.h\"
  rm -f \"${ridir}/include/event.h\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
