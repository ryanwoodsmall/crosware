#
# XXX - mandoc with/instead of groff?
# XXX - add html docs?
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
rver="2.34.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.xz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="fd6cb9b26665794c61f9ca917dcf00e7c19b0c02be575ad6ba9354fa6962411f"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl gettexttiny libssh2 groff busybox less cacertificates nghttp2 openssh"

. "${cwrecipe}/common.sh"
. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \
    \"${rurl//${rname}-${rver}/${rname}-manpages-${rver}}\" \
    \"${rdlfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \
    \"47eafa3517ef5fc7a6e914ad2ee6a6e4d830a4bb6830dba13175850860492c72\"
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
