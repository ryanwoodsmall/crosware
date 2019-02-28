rname="9base"
rver="09e95a2d6f8dbafc6601147b2f5f150355813be6"
rdir="${rname}-${rver}"
rurl="https://git.suckless.org/${rname}"
rprof="${cwetcprofd}/zz_${rname}.sh"
rreqs="make"
rsha256=""
rfile=""

. "${cwrecipe}/common.sh"

eval "
function cwfetch_${rname}() {
  cwscriptecho \"fetching ${rname} from git at ${rurl}\"
  pushd \"${cwbuild}\" >/dev/null 2>&1
  rm -rf \"${rdir}\"
  \${CW_GIT_CMD} clone \"${rurl}\" \"${rdir}\"
  cd \"${rdir}\"
  \${CW_GIT_CMD} checkout \"${rver}\"
  \${CW_GIT_CMD} log | head -6
  popd >/dev/null 2>&1
}
"

eval "
function cwextract_${rname}() {
  cwscriptecho \"cwextract_${rname} noop\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
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
