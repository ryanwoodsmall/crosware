rver="11.62.17-ca-jdk11.0.18"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="9f5ac83b584a297c792cc5feb67c752a2d9fc1259abec3a477e96be8b672f452"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="8ba7a6bc773f934bc95d1e26a3209e97ae947905df284548b0628be5864a8f0b"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="f79c37ff6873f0eb3b82cf1e8bc302ee078c658631eade9d6ba9bdc69728e113"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="6fae6811b0f3aebb14c3e59a5fde14481cff412ef8ca23221993f1ab33269aab"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
