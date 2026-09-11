rname="uftpd"
rver="2.17"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/uftpd/releases/download/v${rver}/${rfile}"
rsha256="e5c7701a3b344d3d31849369f1b9549903e71644540cfb012e3637b3c1a3302f"
rreqs="bootstrapmake libuev libite pkgconf"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{libite,libuev}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{libite,libuev}/current/lib) -static -s\" \
    PKG_CONFIG=\"${cwsw}/pkgconf/current/bin/pkgconf\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{libite,libuev}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
