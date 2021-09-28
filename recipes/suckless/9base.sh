rname="9base"
rver="63916da7bd6d73d9a405ce83fc4ca34845667cce"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/ryanwoodsmall/crosware-source-mirror/raw/master/${rname}/${rfile}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rsha256="8adfe39b52fb9c23bd4b575e0a64e158aef4259f7ca6b53d9b40708b5284085e"
rreqs="bootstrapmake sbase"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/suckless/suckless.sh.common"

eval "
function cwfetch_${rname}() {
  local fv='dc60de7b64948e89832f03181e6db799060036b8'
  local nv='54e49ccfaf48fba913c3471867e19ebf774c1dc5'
  local lv='54e49ccfaf48fba913c3471867e19ebf774c1dc5'
  local mv='54e49ccfaf48fba913c3471867e19ebf774c1dc5'
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \"${rurl//${rfile}/fortunes-\${fv}}\" \"${rdlfile//${rfile}/fortunes-\${fv}}\" \"c826764ff7cf53b1e4a4a7f4cb90aafad957d782e3eccc1bce31bdd0b61480b7\"
  cwfetchcheck \"${rurl//${rfile}/lc-\${lv}}\" \"${rdlfile//${rfile}/lc-\${lv}}\" \"025e787e514a83e3f70e06c5dc8e675b8cb3af69a4037490bfcd75d7a9cc370d\"
  cwfetchcheck \"${rurl//${rfile}/mc-\${mv}}\" \"${rdlfile//${rfile}/mc-\${mv}}\" \"fd3d52ce7d588ffcfef55f2d15b8243a9e050bd35b65aeb14511acb58065555e\"
  cwfetchcheck \"${rurl//${rfile}/${rname}-\${nv}}\" \"${rdlfile//${rfile}/${rname}-\${nv}}\" \"534c549c99900390760950cde419c319c7b1a3f7dce28f817d1acfb223daa331\"
  ln -sf \"${rdlfile//${rfile}/fortunes-\${fv}}\" \"${rdlfile//${rfile}/fortunes}\"
  ln -sf \"${rdlfile//${rfile}/lc-\${lv}}\" \"${rdlfile//${rfile}/lc}\"
  ln -sf \"${rdlfile//${rfile}/mc-\${mv}}\" \"${rdlfile//${rfile}/mc}\"
  ln -sf \"${rdlfile//${rfile}/${rname}-\${nv}}\" \"${rdlfile//${rfile}/${rname}}\"
  unset fv nv lv mv
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/lib\"
  cwmkdir \"${ridir}/bin\"
  install -m 0644 \"\$(realpath ${rdlfile//${rfile}/fortunes})\" \"${ridir}/lib/fortunes\"
  install -m 0755 \"\$(realpath ${rdlfile//${rfile}/lc})\" \"${ridir}/bin/lc\"
  install -m 0755 \"\$(realpath ${rdlfile//${rfile}/mc})\" \"${ridir}/bin/mc\"
  install -m 0755 \"\$(realpath ${rdlfile//${rfile}/${rname}})\" \"${ridir}/bin/${rname}\"
  sed -i 's,/opt/9base,${ridir},g' \"${ridir}/bin/${rname}\"
  ln -sf \"${rname}\" \"${ridir}/bin/9\"
  grep -ril /usr/local/plan9 . \
  | grep -v '\.git' \
  | xargs sed -i \"s#/usr/local/plan9#${ridir}#g\"
  sed -i '/^PREFIX/d' config.mk
  sed -i '/^CC/d' config.mk
  echo \"CC = \${CC} -fcommon\" >> config.mk
  echo \"PREFIX = ${ridir}\" >> config.mk
  if [[ ${karch} =~ x86_64 ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo \"OBJTYPE = x86_64\" >> config.mk
  elif [[ ${karch} =~ a(arch|rm) ]] ; then
    sed -i '/^OBJTYPE/d' config.mk
    echo \"OBJTYPE = arm\" >> config.mk
  fi
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  rm -f \"${ridir}/bin/9yacc\"
  mv \"${ridir}/bin/yacc\" \"${ridir}/bin/9yacc\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${cwsw}/plan9port/current/bin\"' > \"${rprof}\"
  echo 'export PLAN9=\"${rtdir}/current\"' >> \"${rprof}\"
  echo 'append_path \"\${PLAN9}/bin\"' >> \"${rprof}\"
}
"
