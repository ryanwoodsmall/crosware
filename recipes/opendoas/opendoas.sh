#
# XXX - shadow *only* - think of this as a localhost-only sudo (i.e., no PAM, no crap, harder to break)
# XXX - need a way to automatically setuid to root
# XXX - would require sudo? ugh?
# XXX - if [[ ! $(stat -c '%U' $(which doas)) == root ]] ; then sudo chown root $(which doas) ; sudo chmod u+s $(which doas) ; fi
# XXX - capture in a wrapper and call doas.real or doas.bin? hmm
# XXX - move config to ${cwtop}/etc/opendoas/doas.conf?
#

rname="opendoas"
rver="6.8.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/Duncaen/OpenDoas/releases/download/v${rver}/${rfile}"
rsha256="28dca29adec5f4336465812d9e2243f599e62a78903de71c24f0cd6fe667edac"
rreqs="make byacc"
rmessage="bin/doas requires setuid root; try: 'pushd ${cwsw}/opendoas/current/bin/ ; sudo chown root doas ; sudo chmod u+s doas ; popd'"

. "${cwrecipe}/common.sh"

# XXX - ugh,
eval "
function cwpatch_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG '/parseconfig.*DOAS/s/1/0/g' doas.c
  popd >/dev/null 2>&1
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env \
    BINOWN=\"\$(cwgetuser)\" \
    BINGRP=\"\$(cwgetgroup)\" \
    CPPFLAGS= \
    LDFLAGS=-static \
      ./configure ${cwconfigureprefix} \
        --sysconfdir=\"${ridir}/etc\" \
        --enable-static \
        --without-pam
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  ln -sf doas \"${ridir}/bin/${rname}\"
  mkdir \"${ridir}/etc\"
  local dc=\"${ridir}/etc/doas.conf\"
  echo -n | tee \"\${dc}\"
  touch \"\${dc}\"
  chmod 0660 \"\${dc}\"
  echo 'permit nopass root' | tee -a \"\${dc}\"
  echo 'permit nopass :wheel' | tee -a \"\${dc}\"
  echo 'permit nopass chronos' | tee -a \"\${dc}\"
  grep -q \"permit nopass \$(cwgetuser)\" \"\${dc}\" \
  || { echo \"permit nopass \$(cwgetuser)\" | tee -a \"\${dc}\" ; }
  chmod -R g+rw \"${ridir}/\"
  find \"${ridir}/\" -type d -exec chmod 2775 {} +
  unset dc
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"
