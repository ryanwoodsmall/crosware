#
# XXX - add html docs?
# XXX - cool git proxy stuff: https://gitolite.com/git-over-proxy.html
#
# git will use whatever "ssh" command is in the $PATH
# this can break with dropbear's dbclient -> ssh symlink
# git can be configured to use "openssh"
# these are provided by the openssh/opensshlibressl packages
#
#   export GIT_SSH_COMMAND='openssh'
#   git config --global core.sshCommand 'openssh'
#
# these can be used to pass additional options to the ssh cli
# to i.e. use a specific key, set IdentitiesOnly options, etc.
#
# additionally, the "simple" ssh variant can be used to turn off openssh specifics
# i.e. spuriuos SendEnv=GIT_PROTOCOL
# note that this won't make dropbear work
#
#   export GIT_SSH_VARIANT=simple
#   git config --global ssh.variant simple
#
# links:
# - https://git-scm.com/docs/git-config#Documentation/git-config.txt-coresshCommand
# - https://git-scm.com/docs/git-config#Documentation/git-config.txt-sshvariant
# - https://stackoverflow.com/questions/4565700/how-to-specify-the-private-ssh-key-to-use-when-executing-shell-command-on-git
#

rname="git"
rver="2.35.3"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="15e9db4f9bf2ed9fff30cb62a00c5c7c0901015f5ab048cdb4e8b04ddee00fa2"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl libssh2 busybox less cacertificates nghttp2 openssh mandoc"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \
    \"${rurl//${rname}-${rver}/${rname}-manpages-${rver}}\" \
    \"${rdlfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \
    \"a78c7ee00731cfa903fdf17e3af472c6413c1e014cedd771f6d29932def1e324\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"${rbdir}\" >/dev/null 2>&1
  env PATH=\"\${cwsw}/curl/current/bin:\${PATH}\" \
    ./configure ${cwconfigureprefix} \
      --with-curl \
      --with-expat \
      --with-libpcre2 \
      --with-openssl=\"${cwsw}/openssl/current\" \
      --with-perl=\"${cwsw}/perl/current/bin/perl\" \
      --without-iconv \
      --without-python \
      --without-tcltk \
        CC=\"\${CC}\" \
        CXX=\"\${CXX}\" \
        CFLAGS=\"\${CFLAGS}\" \
        CXXFLAGS=\"\${CXXFLAGS}\" \
        LDFLAGS=\"\${LDFLAGS}\" \
        LIBS='-lcurl -lnghttp2 -lssh2 -lssl -lcrypto -lz'
  sed -i.ORIG 's/-lcurl/-lcurl -lnghttp2 -lssh2 -lssl -lcrypto -lz/g' Makefile
  grep -ril sys/poll\\.h ${rbdir}/ \
  | grep \\.h\$ \
  | xargs sed -i.ORIG 's#sys/poll\.h#poll.h#g'
  popd >/dev/null 2>&1
}
"
