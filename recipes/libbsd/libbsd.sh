rname="libbsd"
rver="0.8.7"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://libbsd.freedesktop.org/releases/${rfile}"
rsha256="f548f10e5af5a08b1e22889ce84315b1ebe41505b015c9596bad03fd13a12b31"
rreqs="make"

. "${cwrecipe}/common.sh"

eval "
function cwconfigure_${rname}() {
  pushd "${rbdir}" >/dev/null 2>&1
  sed -i.ORIG '/__GLIBC_PREREQ/ s|^#if |#if 1 //|g' include/bsd/string.h include/bsd/stdlib.h 
  for h in \$(egrep -rl '__(BEGIN|END)_DECLS' include | grep -v '/cdefs\.h$') ; do
    echo "attempting to fix up \${h}"
    cat \${h} > \${h}.ORIG
    sed '/^#ifndef __BEGIN_DECLS/,/^$/!d' include/bsd/sys/cdefs.h > \${h}
    cat \${h}.ORIG >> \${h}
  done
  ./configure ${cwconfigureprefix} ${cwconfigurelibopts} LDFLAGS='-static' CPPFLAGS=''
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_ldflags \"-L${rtdir}/current/lib\"' > \"${rprof}\"
  echo 'append_pkgconfigpath \"${rtdir}/current/lib/pkgconfig\"' >> \"${rprof}\"
  echo 'append_cppflags \"-I${rtdir}/current/include\"' >> \"${rprof}\"
}
"
