rver="11.52.13-ca-jdk11.0.13"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="6be187379c26506a4b804b4f734c17e554aebe4204bde58a10b429054cc9cf9f"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="55eefd0c9b5fb70953e082576d86399f6426158cf79f14301ab55c2975abed4b"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="fd64644c815875e5a3e6f009fcfd3972f17afd724c280daf8d6d27c66cf8c6a9"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="77a126669b26b3a89e0117b0f28cddfcd24fcd7699b2c1d35f921487148b9a9f"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
