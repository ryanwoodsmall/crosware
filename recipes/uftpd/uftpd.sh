rname="uftpd"
rver="2.15"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/troglobit/uftpd/releases/download/v${rver}/${rfile}"
rsha256="6c9c5bd40499af772e00cae10ef54e80e39d189d62cc6d7e13ac10929a700ccf"
rreqs="bootstrapmake libuev libite pkgconfig"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  ./configure ${cwconfigureprefix} ${rconfigureopts} ${rcommonopts} \
    CPPFLAGS=\"\$(echo -I${cwsw}/{libite,libuev}/current/include)\" \
    LDFLAGS=\"\$(echo -L${cwsw}/{libite,libuev}/current/lib) -static -s\" \
    PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{libite,libuev}/current/lib/pkgconfig | tr ' ' ':')\"
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > \"${rprof}\"
}
"
