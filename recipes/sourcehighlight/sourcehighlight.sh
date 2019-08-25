rname="sourcehighlight"
rver="1.11"
rdir="${rname//source/source-}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://ftp.gnu.org/gnu/src-highlite/${rfile}"
rsha256="ba2b6d00e74de71d22ff798af23894b9e6920a17c369f66e925b192fab43dd6d"
rreqs="make ctags less"

. "${cwrecipe}/common.sh"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  echo '#!/bin/sh' > \"${ridir}/bin/srchilite\"
  echo '${cwsw}/${rname}/current/bin/source-highlight -f esc -o STDOUT -i \"\${@}\"' >> \"${ridir}/bin/srchilite\"
  chmod 755 \"${ridir}/bin/srchilite\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

#source-highlight -f esc -o STDOUT -i
