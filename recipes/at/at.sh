#
# XXX - hideous uid/user figuring
#
rname="at"
rver="3.2.1"
rdir="${rname}-${rver}"
rfile="${rname}_${rver}.orig.tar.gz"
rurl="http://software.calhariz.com/${rname}/${rfile}"
rsha256="aabe6e5cb6dd19fe9fb25c2747492f2db38762b95ea41b86f949609c39fb55c4"
rreqs="make byacc reflex configgit"

. "${cwrecipe}/common.sh"

# glibc-specific workaround via: https://www.openembedded.org/pipermail/openembedded-core/2015-April/103802.html
eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  local u g
  u=\$(cut -f1,3 -d: /etc/passwd | grep \${UID}\$ | cut -f1 -d: | head -1)
  g=\$(cut -f1,3 -d: /etc/group | grep \${GROUPS[0]}\$ | cut -f1 -d: | head -1)
  sed -i.ORIG 's/-o root -g root/-g root -o root/g' Makefile.in
  sed -i \"/INSTALL/s/-g root -o root/-g \${GROUPS[0]} -o \${UID}/g\" Makefile.in
  sed -i \"/INSTALL/s/-o root/-o \${UID}/g\" Makefile.in
  #sed -i '/INSTALL.*etcdir/d' Makefile.in
  sed -i.ORIG 's,PIDDIR=/var/run,PIDDIR=${cwtop}/var/run,g' configure
  sed -i 's,/var/spool/cron,${cwtop}/var/spool/cron,g' configure
  ./configure ${cwconfigureprefix} \
    --localstatedir=\"${cwtop}/var\" \
    --runstatedir=\"${cwtop}/var/run\" \
    --with-etcdir=\"${cwtop}/var/etc\" \
    --with-jobdir=\"${cwtop}/var/spool/at/atjobs\" \
    --with-atspool=\"${cwtop}/var/spool/at/atspool\" \
    --with-daemon_username=\"\${u}\" \
    --with-daemon_groupname=\"\${g}\" \
      YACC=\"${cwsw}/byacc/current/bin/byacc\" \
      LIBS=-lrefl
  #cat parsetime.y > parsetime.y.ORIG
  #echo '#define is_leap_year(y) ((y) % 4 == 0 && ((y) % 100 != 0 || (y) % 400 == 0))' >> parsetime.y
  #sed -i.ORIG 's/__isleap/is_leap_year/g' parsetime.y
  unset u g
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
