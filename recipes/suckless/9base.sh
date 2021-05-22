rname="9base"
rver="63916da7bd6d73d9a405ce83fc4ca34845667cce"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rsha256="8adfe39b52fb9c23bd4b575e0a64e158aef4259f7ca6b53d9b40708b5284085e"
rreqs="bootstrapmake"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/suckless/suckless.sh.common"

eval "
function cwfetch_${rname}() {
  local fv='dc60de7b64948e89832f03181e6db799060036b8'
  local nv='9e8366c25e77fb33de5ed76cbbcd44dcc8604fde'
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rfile}/fortunes-\${fv}}\" \"${rdlfile//${rfile}/fortunes-\${fv}}\" \"c826764ff7cf53b1e4a4a7f4cb90aafad957d782e3eccc1bce31bdd0b61480b7\"
  cwfetchcheck \"${rurl//${rfile}/${rname}-\${nv}}\" \"${rdlfile//${rfile}/${rname}-\${nv}}\" \"9cdae14e5167255cf203b88cfcad5800c09daa4fb3fad2ad32b7c77c3b6d1b8b\"
  ln -sf \"${rdlfile//${rfile}/fortunes-\${fv}}\" \"${rdlfile//${rfile}/fortunes}\"
  ln -sf \"${rdlfile//${rfile}/${rname}-\${nv}}\" \"${rdlfile//${rfile}/${rname}}\"
  unset fv nv
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/lib\"
  cwmkdir \"${ridir}/bin\"
  install -m 0644 \"\$(realpath ${rdlfile//${rfile}/fortunes})\" \"${ridir}/lib/fortunes\"
  echo '#!/bin/sh' > \"${ridir}/bin/${rname}\"
  echo 'PLAN9=\${PLAN9:-${ridir}}' >> \"${ridir}/bin/${rname}\"
  grep -v '^#' \"\$(realpath ${rdlfile//${rfile}/${rname}})\" | grep -v '^\$' >> \"${ridir}/bin/${rname}\"
  chmod 755 \"${ridir}/bin/${rname}\"
  ln -sf \"${rname}\" \"${ridir}/bin/9\"
  grep -ril /usr/local/plan9 . \
  | grep -v '\.git' \
  | xargs sed -i "s#/usr/local/plan9#${ridir}#g"
  sed -i '/^PREFIX/d' config.mk
  sed -i '/^CC/d' config.mk
  echo "CC = \${CC}" >> config.mk
  echo "PREFIX = ${ridir}" >> config.mk
  if [[ ${karch} =~ x86_64 ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo "OBJTYPE = x86_64" >> config.mk
  elif [[ ${karch} =~ a(arch|rm) ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo "OBJTYPE = arm" >> config.mk
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'export PLAN9=\"${rtdir}/current\"' > \"${rprof}\"
  echo 'append_path \"\${PLAN9}/bin\"' >> \"${rprof}\"
}
"
