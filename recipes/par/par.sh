#
# XXX - move to upstream? http://www.nicemice.net/par/
#

rname="par"
rver="1.52"
rdir="${rname}-${rver}.orig"
rfile="${rdir//-/_}.tar.gz"
rurl="http://deb.debian.org/debian/pool/main/p/${rname}/${rfile}"
rsha256="d5822ed7297c29034f415d1cb0a958bc4476139fe196ff36bd8b705dcb9fdf3f"
rreqs="make"
rdldfile="${rfile//.orig.tar.gz/-3.diff.gz}"

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rfile}/${rdldfile}}\" \"${cwdl}/${rname}/${rdldfile}\" \"fd90eed9489f5da841bb1d7f726c3fbabe3872614ad84903c09f8b32ae744ec4\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  gzip -dc < \"${cwdl}/${rname}/${rdldfile}\" | patch -p1
  for p in \$(cat debian/patches/series) ; do
    patch -p1 < debian/patches/\${p}
  done
  sed -i.ORIG \"/^LINK1/s/=.*/= \${CC} -static/g\" protoMakefile
  sed -i.ORIG \"s#/usr#${ridir}#g\" Makefile
  sed -i 's/install -o/install -D -o/g' Makefile
  sed -i '/install /s/-o root -g root//g' Makefile
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rdldfile
