#!/usr/bin/env bash
#
# install musl-based zulu jdk "out of tree"
#
# XXX - keep using astron file file for a little more precision w/executables and libs/objects
# XXX - toybox file would be a better fit/faster, but...
#   /usr/local/zulu/zulu17.50.19-ca-jdk17.0.11-linux_musl_x64/bin/java: ELF shared object, 64-bit LSB x86-64, dynamic (/lib/ld-musl-x86_64.so.1), not stripped
#

# only run if we're have valid crosware
if ! command -v crosware &>/dev/null ; then
  echo 'crosware not found'
  exit 1
fi
if [ "${cwtop}x" == "x" ] ; then
 echo '${cwtop} environment variable not set'
 exit 1
fi
if ! $(uname -m | grep -qE '^(x86_64|aarch64)$') ; then
  echo 'x86_64/aarch64 only'
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
  8|11|17|21) :
    echo "installing zulu ${reqver} musl..."
    echo "getting full version..."
    zuluver="$(crosware run-func cwver_zulu${reqver}musl)"
    echo "getting sha256 checksum..."
    zulusha="$(crosware run-func cwsha256_zulu${reqver}musl)"
    ;;
  all) :
    bash "${BASH_SOURCE[0]}" 17
    bash "${BASH_SOURCE[0]}" 8
    bash "${BASH_SOURCE[0]}" 11
    bash "${BASH_SOURCE[0]}" 21
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
    echo "${BASH_SOURCE[0]} [8|11|17|21|all|custom]"
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
if $(uname -m | grep -q x86_64) ; then
  : ${zuludir:="zulu${zuluver}-linux_musl_x64"}
elif $(uname -m | grep -q aarch64) ; then
  : ${zuludir:="zulu${zuluver}-linux_musl_aarch64"}
else
  echo "$(uname -m) not supported"
  exit 1
fi
: ${zulufile:="${zuludir}.tar.gz"}
: ${zuluurl:="${zulucdn}/${zulufile}"}
: ${zuludldir:="${cwdl}/zulu"}
: ${zuludlfile:="${zuludldir}/${zulufile}"}

# we need file, zlib, and patchelf
for req in file zlib patchelf ; do
  echo "checking prereq ${req}..."
  crosware check-installed ${req} || crosware install ${req}
done
. "${cwtop}/etc/profile"

# download everything
echo "downloading ${zuluurl}..."
crosware \
  run-func \
    cwfetchcheck,${zuluurl},${zuludlfile},${zulusha}

# install libz.so in jdk lib dir
install -m 0755 -D $(realpath ${cwsw}/zlib/current/shared/lib/libz.so) ${zulutop}/${zuludir}/lib/libz.so.1
ln -sf libz.so.1 ${zulutop}/${zuludir}/lib/libz.so

# install zulu jdk
echo "extracting ${zuludlfile} to ${zulutop}..."
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
echo "writing ${zuluprofd}"
cat > ${zuluprofd} << EOF
export JAVA_HOME="${zulutop}/current"
export PATH="\${JAVA_HOME}/bin:\${PATH}"
export _JAVA_OPTIONS="-Djava.io.tmpdir=${cwtmp} -Djava.awt.headless=true -XX:-UsePerfData"
EOF

echo "done; run the following to pick up the new environment:"
echo "  . ${cwtop}/scripts/reset-cwenv.sh"
