rname="patch"
rver="2.8"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/${rname}/${rfile}"
rsha256="308a4983ff324521b9b21310bfc2398ca861798f02307c79eb99bb0e0d2bf980"
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
