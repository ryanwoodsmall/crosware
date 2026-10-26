rname="patch"
rver="2.8.1"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="0f7b43c7ea450c5d3e9eaf8301177628bc0171d580b2bd6a72822409767144ff"
rreqs="bootstrapmake toybox"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    unset CPPFLAGS PKG_CONFIG_{LIBDIR,PATH}
    export LDFLAGS=-static
    ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} SED=\"${cwsw}/toybox/current/bin/sed\"
  )
  popd &>/dev/null
}
"

eval "
function cwmake_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  (
    cwmkdir ./tempbin
    ln -sf \"${cwsw}/toybox/current/bin/sed\" ./tempbin/
    export PATH=\"\${PWD}/tempbin:\${PATH}\"
    make -j${cwmakejobs} ${rlibtool}
  )
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'prepend_path \"${rtdir}/current/bin\"' > "${rprof}"
}
"
