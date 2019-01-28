rname="libnl"
rver="3.2.25"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.infradead.org/~tgr/${rname}/files/${rfile}"
rsha256="8beb7590674957b931de6b7f81c530b85dc7c1ad8fbda015398bc1e8d1ce8ec5"
rreqs="make bison"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG 's#sys/poll.h#poll.h#g' include/netlink/netlink.h
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} YACC=\"${cwsw}/bison/current/bin/bison -Wno-yacc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/sbin\"' > "${rprof}"
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include/libnl3\"' >> \"${rprof}\"
}
"
