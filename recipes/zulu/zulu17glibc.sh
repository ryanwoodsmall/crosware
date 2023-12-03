rver="17.46.19-ca-jdk17.0.9"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="90062201e7911696a449431a61dc0a55cd10cda516a9f2db54c410633a79302a"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="2e0923c1288091df7c63ed1e3cbcdd54cb96259857c89a79021d5f9a0c64427a"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="3ccac20693901dd61b26dd66e0f010c7c27b9e99463d06ee213de7085a1d4b2e"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="5317630424ee4e4d2c1024240d2e6f94a7c06d17b01dd36859df4a4d679fc287"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
