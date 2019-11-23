#!/usr/bin/env bash
#
# dirtier version of this
# https://github.com/ryanwoodsmall/dockerfiles/blob/master/crosware/zulu/Dockerfile
#

if ! $(hash crosware >/dev/null 2>&1) ; then
  echo 'crosware not found'
  exit 1
fi

if [ "${cwtop}x" == "x" ] ; then
 echo '${cwtop} environment variable not set'
 exit 1
fi

set -eu

cwtmp="$(cd ${cwtop}/../tmp && pwd)"
cwdl="${cwtop}/downloads"

zulucdn="https://cdn.azul.com/zulu/bin"
zulutop="/usr/local/zulu"
zuluprofd="${cwetc}/local.d/zulu.sh"
zuluver="8.42.0.23-ca-jdk8.0.232"
zuludir="zulu${zuluver}-linux_musl_x64"
zulufile="${zuludir}.tar.gz"
zuluurl="${zulucdn}/${zulufile}"
zulusha="2735d6e456b9194ec8843e5874ef2820e9e54d00aa4cb19c01174722d65ad7a5"
zuludldir="${cwdl}/zulu"
zuludlfile="${zuludldir}/${zulufile}"

crosware \
  run-func \
    cwfetchcheck,${zuluurl},${zuludlfile},${zulusha} \
    cwextract,${zuludlfile},${zulutop} \
    cwlinkdir,${zuludir},${zulutop}

for l in {/usr,}/lib{,64} ; do
  test -e ${l} || ln -s ${cwsw}/statictoolchain/current/$(gcc -dumpmachine)/lib ${l}
done

cat > ${zuluprofd} << EOF
export JAVA_HOME="${zulutop}/current"
export PATH="\${JAVA_HOME}/bin:\${PATH}"
export _JAVA_OPTIONS="-Djava.io.tmpdir=${cwtmp} -Djava.awt.headless=true"
EOF
