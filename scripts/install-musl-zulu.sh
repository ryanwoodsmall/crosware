#!/usr/bin/env bash

#
# dirtier version of this:
#  https://github.com/ryanwoodsmall/dockerfiles/blob/master/crosware/zulu/Dockerfile
#
# XXX - check for musl...
#

# only run if we're have valid crosware
if ! $(hash crosware >/dev/null 2>&1) ; then
  echo 'crosware not found'
  exit 1
fi
if [ "${cwtop}x" == "x" ] ; then
 echo '${cwtop} environment variable not set'
 exit 1
fi
if ! $(crosware show-uarch | grep -q '^x86_64$') ; then
  echo 'x86_64 only'
  exit 1
fi

# fail fast from here on out
set -eu

# default to jdk 8
if [ ${#} -lt 1 ] ; then
  reqver=8
else
  reqver="${1}"
fi

# version picker
case "${reqver}" in
    8) zuluver="8.44.0.11-ca-jdk8.0.242"
       zulusha="1910df13769824abdf82ce565e3150d6c2fa455f752133b092e5e800caef5f80"
       ;;
   11) zuluver="11.37.17-ca-jdk11.0.6"
       zulusha="7c97f078d34116e434467026d6740346af79558cc8628f27d36324f8ed67921b"
       ;;
  all) bash "${BASH_SOURCE[0]}" 8
       bash "${BASH_SOURCE[0]}" 11
       exit 0
       ;;
    *) echo "${BASH_SOURCE[0]} [8|11|all]"
       exit 1
       ;;
esac

# crosware vars
cwbuild="${cwtop}/builds"
cwdl="${cwtop}/downloads"
cwtmp="$(cd ${cwtop}/../tmp && pwd)"

# zulu vars
zulucdn="https://cdn.azul.com/zulu/bin"
zulutop="/usr/local/zulu"
zuluprofd="${cwetc}/local.d/zulumusl.sh"
zuludir="zulu${zuluver}-linux_musl_x64"
zulufile="${zuludir}.tar.gz"
zuluurl="${zulucdn}/${zulufile}"
zuludldir="${cwdl}/zulu"
zuludlfile="${zuludldir}/${zulufile}"

# libz vars
libzdir="libz-1.2.8.2015.12.26"
libzfile="${libzdir}.tar.gz"
libzurl="https://sortix.org/libz/release/${libzfile}"
libzsha="abcc2831b7a0e891d0875fa852e9b9510b420d843d3d20aad010f65493fe4f7b"
libzdldir="${cwdl}/libz"
libzdlfile="${libzdldir}/${libzfile}"
libzbuilddir="${cwbuild}/${libzdir}"

# we need make
crosware check-installed make || crosware install make
. "${cwtop}/etc/profile"

# build and install a sortix libz.so
rm -rf ${libzbuilddir}
crosware \
  run-func \
    cwfetchcheck,${libzurl},${libzdlfile},${libzsha} \
    cwextract,${libzdlfile},${cwbuild}
{
  cd ${libzbuilddir}/
  env CFLAGS= CPPFLAGS= LDFLAGS= ./configure --enable-shared --disable-static
  make
  install -m 0755 -D $(realpath libz.so) ${zulutop}/${zuludir}/lib/libz.so.1
}
{
  cd ${zulutop}/${zuludir}/lib/
  ln -sf libz.so{.1,}
}
rm -rf ${libzbuilddir}

# install zulu jdk
crosware \
  run-func \
    cwfetchcheck,${zuluurl},${zuludlfile},${zulusha} \
    cwextract,${zuludlfile},${zulutop} \
    cwlinkdir,${zuludir},${zulutop}

# we (conditionally) need some symlinks for libc.so
for l in {/usr,}/lib{,64} ; do
  test -e ${l} || ln -s ${cwsw}/statictoolchain/current/$(gcc -dumpmachine)/lib ${l}
done

# write out the profile
cat > ${zuluprofd} << EOF
export JAVA_HOME="${zulutop}/current"
export PATH="\${JAVA_HOME}/bin:\${PATH}"
export _JAVA_OPTIONS="-Djava.io.tmpdir=${cwtmp} -Djava.awt.headless=true"
EOF
