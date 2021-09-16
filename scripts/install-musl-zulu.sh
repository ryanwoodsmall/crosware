#!/usr/bin/env bash
#
# install musl-based zulu jdk "out of tree"
#
# XXX - use alpine openjdk .apk packages instead - may work on other arches? ssl/nss/x11?
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

# default to jdk 11
if [ ${#} -lt 1 ] ; then
  reqver=11
else
  reqver="${1}"
fi

# version picker
case "${reqver}" in
  8|11|17) :
    zuluver="$(awk -F'"' '/^rver=/{print $2}' ${cwtop}/recipes/zulu/zulu${reqver}musl.sh)"
    zulusha="$(awk -F'"' '/^rsha256=/{print $2}' ${cwtop}/recipes/zulu/zulu${reqver}musl.sh)"
    ;;
  all) :
    bash "${BASH_SOURCE[0]}" 17
    bash "${BASH_SOURCE[0]}" 8
    bash "${BASH_SOURCE[0]}" 11
    exit 0
    ;;
  custom) :
    : ${zuluver:=""}
    : ${zulusha:=""}
    if [ ${#} -ge 3 ] ; then
      if [ -z "${zuluver}" ] ; then
        zuluver="${2}"
      fi
      if [ -z "${zulusha}" ] ; then
        zulusha="${3}"
      fi
    fi
    if [[ -z "${zuluver}" || -z "${zulusha}" ]] ; then
      echo "${BASH_SOURCE[0]} custom [[zuluver] [zulusha]]: 'zuluver' and 'zulusha' must be passed or environment variables must be set"
      echo "  env zulusha=a1b2c3... zuluver=1.2.3-ca-jdk99.0.0 ${BASH_SOURCE[0]} custom"
      exit 1
    fi
    ;;
  *) :
    echo "${BASH_SOURCE[0]} [8|11|17|all|custom]"
    exit 1
    ;;
esac

# crosware vars
cwbuild="${cwtop}/builds"
cwdl="${cwtop}/downloads"
cwtmp="$(cd ${cwtop}/../tmp && pwd)"

# zulu vars
: ${zulucdn:="https://cdn.azul.com/zulu/bin"}
: ${zulutop:="/usr/local/zulu"}
: ${zuluprofd:="${cwetc}/local.d/zulumusl.sh"}
: ${zuludir:="zulu${zuluver}-linux_musl_x64"}
: ${zulufile:="${zuludir}.tar.gz"}
: ${zuluurl:="${zulucdn}/${zulufile}"}
: ${zuludldir:="${cwdl}/zulu"}
: ${zuludlfile:="${zuludldir}/${zulufile}"}

# we need file, libz, and patchelf
for req in file libz patchelf ; do
  crosware check-installed ${req} || crosware install ${req}
done
. "${cwtop}/etc/profile"

# download everything
crosware \
  run-func \
    cwfetchcheck,${zuluurl},${zuludlfile},${zulusha}

# install sortix libz.so in jdk lib dir
install -m 0755 -D $(realpath ${cwsw}/libz/current/lib/libz.so) ${zulutop}/${zuludir}/lib/libz.so.1
ln -sf libz.so.1 ${zulutop}/${zuludir}/lib/libz.so

# install zulu jdk
crosware \
  run-func \
    cwextract,${zuludlfile},${zulutop} \
    cwlinkdir,${zuludir},${zulutop}

# patchelf any ELF binaries
find ${zulutop}/${zuludir} -type f -exec ${cwsw}/file/current/bin/file {} + \
| grep 'ELF.*executable' \
| cut -f1 -d: \
| sort \
| while read -r i ; do
    echo patching ${i}
    ${cwsw}/patchelf/current/bin/patchelf --set-interpreter ${cwsw}/statictoolchain/current/$(${cwsw}/statictoolchain/current/bin/gcc -dumpmachine)/lib/ld.so ${i}
  done

# write out the profile
cat > ${zuluprofd} << EOF
export JAVA_HOME="${zulutop}/current"
export PATH="\${JAVA_HOME}/bin:\${PATH}"
export _JAVA_OPTIONS="-Djava.io.tmpdir=${cwtmp} -Djava.awt.headless=true -XX:-UsePerfData"
EOF
