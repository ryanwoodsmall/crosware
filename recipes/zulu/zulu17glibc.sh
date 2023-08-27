rver="17.44.15-ca-jdk17.0.8"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="af72edfd8d9f060c7e0d09330d02fb9cc2dcc9fc6cbc4d434de695f1c7405a21"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="4feb1f6cba26c66160e03284b876071ee9d27954df2e2be51def935afc30d8d9"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="bc84c25f53f6961c5649f1fd363e944d48113ead07020ba90a2b3d53cea1b5eb"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="423d1f40e0cbe873f357cebb95b19a59503948ee3c91639ecbc8e64df6a6f5fc"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
