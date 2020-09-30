rname="at"
rver="3.1.23"
rdir="${rname}-${rver}"
rfile="${rname}_${rver}.orig.tar.gz"
rurl="http://ftp.debian.org/debian/pool/main/a/${rname}/${rfile}"
rsha256="97450aa954aaa8a70218cc8e61a33df9fee9f86527e9f861de302fb7a3c81710"
rreqs="make byacc reflex configgit"

. "${cwrecipe}/common.sh"

# glibc-specific workaround via: https://www.openembedded.org/pipermail/openembedded-core/2015-April/103802.html
eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  sed -i.ORIG \"/INSTALL/s/-g root -o root/-g \${GROUPS[0]} -o \${UID}/g\" Makefile.in
  ./configure ${cwconfigureprefix} \
    --with-jobdir=\"${cwtop}/var/spool/at/atjobs\" \
    --with-atspool=\"${cwtop}/var/spool/at/atspool\" \
    --with-daemon_username=\"\${UID}\" \
    --with-daemon_groupname=\"\${GROUPS[0]}\" \
      YACC=\"${cwsw}/byacc/current/bin/byacc\" \
      LIBS=-lrefl
  cat parsetime.y > parsetime.y.ORIG
  echo '#define is_leap_year(y) ((y) % 4 == 0 && ((y) % 100 != 0 || (y) % 400 == 0))' >> parsetime.y
  sed -i.ORIG 's/__isleap/is_leap_year/g' parsetime.y
  popd >/dev/null 2>&1
}
"

eval "
function cwmakeinstall_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  make install ${rlibtool}
  cwmkdir \"${cwtop}/var/spool/at/atjobs\"
  cwmkdir \"${cwtop}/var/spool/at/atspool\"
  popd >/dev/null 2>&1
}
"

eval "
function cwgenprofd_${rname}() {
  echo 'append_path \"${rtdir}/current/bin\"' > \"${rprof}\"
  echo 'append_path \"${rtdir}/current/sbin\"' >> \"${rprof}\"
}
"
