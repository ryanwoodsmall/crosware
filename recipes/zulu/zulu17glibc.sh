rver="17.48.15-ca-jdk17.0.10"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="f4e665f2bb9a2ef8dda60e367c2dc8339982ffd966b210a9a4d7d4bb3fd27fc1"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="a97b78e88a6841941d9cb96aaba6da5ebcfdf98f297a628479ee3face71e049e"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="7d9e8ad489b8d09c8f58c09e5f42e19f1eb0a0aef55814f2c4bb1deedb34b543"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="57284da1bd86d53abf582293d20d18fff7fe243da15a08fa414f6275fbd48fe2"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
