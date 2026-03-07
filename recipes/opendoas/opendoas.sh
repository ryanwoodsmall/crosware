#
# XXX - shadow *only* - think of this as a localhost-only sudo (i.e., no PAM, no crap, harder to break)
# XXX - need a way to automatically setuid to root
# XXX - would require sudo? ugh?
# XXX - if [[ ! $(stat -c '%U' $(which doas)) == root ]] ; then sudo chown root $(which doas) ; sudo chmod u+s $(which doas) ; fi
# XXX - capture in a wrapper and call doas.real or doas.bin? hmm
#
rname="opendoas"
rver="6.8.2"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://github.com/Duncaen/OpenDoas/releases/download/v${rver}/${rfile}"
rsha256="28dca29adec5f4336465812d9e2243f599e62a78903de71c24f0cd6fe667edac"
rreqs="make byacc"
rmessage="bin/doas requires setuid root; try: 'pushd ${cwsw}/opendoas/current/bin/ ; sudo chown root doas ; sudo chmod u+s doas ; popd'"

rconfdir="${cwtop}/etc/opendoas"
rconffile="${rconfdir}/doas.conf"

. "${cwrecipe}/common.sh"

# XXX - ugh,
eval "
function cwpatch_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  sed -i.ORIG '/parseconfig.*DOAS/s/1/0/g' doas.c
  popd &>/dev/null
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  env \
    BINOWN=\"\$(cwgetuser)\" \
    BINGRP=\"\$(cwgetgroup)\" \
    CPPFLAGS= \
    LDFLAGS=-static \
      ./configure ${cwconfigureprefix} \
        --sysconfdir=\"${rconfdir}\" \
        --enable-static \
        --without-pam
  popd &>/dev/null
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
  make install ${rlibtool}
  ln -sf doas \"${ridir}/bin/${rname}\"
  cwmkdir \"${rconfdir}\"
  echo -n | tee \"${rconffile}\"
  touch \"${rconffile}\"
  chmod 0660 \"${rconffile}\"
  echo 'permit nopass root' | tee -a \"${rconffile}\"
  echo 'permit nopass :wheel' | tee -a \"${rconffile}\"
  echo 'permit nopass chronos' | tee -a \"${rconffile}\"
  grep -q \"permit nopass \$(cwgetuser)\" \"${rconffile}\" \
  || { echo \"permit nopass \$(cwgetuser)\" | tee -a \"${rconffile}\" ; }
  chmod -R g+rw \"\$(cwidir_${rname})/\"
  find \"\$(cwidir_${rname})/\" -type d -exec chmod 2775 {} +
  popd &>/dev/null
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
}
"

unset rconfdir rconffile
