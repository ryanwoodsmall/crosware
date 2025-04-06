#
# XXX - 7.2.0.202503040940-r fails with a java.lang.classNotFoundException
# XXX - https://github.com/eclipse-jgit/jgit/issues/157
#
rver="7.1.0.202411261347-r"
rname="jgitsh${rver%%.*}"
rsha256="9d93f77cb73842f4502b55493f9da2d98f83a19dd496059e6c7a520dc35a716e"
. "${cwrecipe}/jgitsh/jgitsh.sh.common"
