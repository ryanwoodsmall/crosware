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
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  cwmkdir \"${ridir}/lib\"
  cwfetch \"https://github.com/9fans/plan9port/raw/master/lib/fortunes\" \"${ridir}/lib/fortunes\"
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
