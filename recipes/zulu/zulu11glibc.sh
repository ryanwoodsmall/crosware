rver="11.60.19-ca-jdk11.0.17"
mver="${rver%%.*}"
rname="zulu${mver}glibc"
rsha256=""

if [[ ${uarch} =~ ^aarch64 ]] ; then
  rsha256="48632fb921cae8fd3914f7297b349b66c602455af26cf1fd1d09a866330c3de1"
elif [[ ${uarch} =~ ^arm ]] ; then
  rsha256="498180dcf87e89b23071a8136da977a0b50052ac2deb222eae77784810ad78ac"
elif [[ ${uarch} =~ ^i.86 ]] ; then
  rsha256="78ce988091f50a1f153909770872ad8e514d447ba663e6de688a82c9884ce6c2"
elif [[ ${uarch} =~ ^x86_64 ]] ; then
  rsha256="d9e9d34d64bc63cd846c88117a731e6550c17866df9501d0d1ae0329f965d78a"
fi

. "${cwrecipe}/${rname%${mver}glibc}/${rname//${mver}glibc/glibc}.sh.common"

unset mver
