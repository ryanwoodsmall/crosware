#
# XXX - add html docs?
# XXX - cool git proxy stuff: https://gitolite.com/git-over-proxy.html
#
# git will use whatever "ssh" command is in the $PATH
# this can break with dropbear's dbclient -> ssh symlink
# e.g., when kex/mac/cipher/key/cert/... types can't find a match
#
# git can be configured to use "openssh" if there are any issues
# the "openssh" command is provided by the openssh or opensshlibressl packages
#
#   export GIT_SSH_COMMAND='openssh'
#   git config --global core.sshCommand 'openssh'
#
# this/these environment variables can be used to pass additional options to the ssh cli
# to i.e. use a specific key, set IdentitiesOnly options, etc.
#
# additionally, the "simple" ssh variant can be used to turn off openssh specifics
# i.e. spurious SendEnv=GIT_PROTOCOL warnings and odd connection drop errors
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
rver="2.47.0"
rdir="${rname}-${rver}"
rfile="${rdir}.tar.gz"
rurl="https://www.kernel.org/pub/software/scm/${rname}/${rfile}"
rsha256="a84a7917e0ab608312834413f01fc01edc7844f9f9002ba69f3b4f4bcb8d937a"
rreqs="make bzip2 zlib openssl curl expat pcre2 perl libssh2 busybox less cacertificates nghttp2 mandoc"

. "${cwrecipe}/${rname}/${rname}.sh.common"

eval "
function cwfetch_${rname}() {
  cwfetchcheck \"${rurl}\" \"${rdlfile}\" \"${rsha256}\"
  cwfetchcheck \
    \"${rurl//${rname}-${rver}/${rname}-manpages-${rver}}\" \
    \"${rdlfile//${rname}-${rver}/${rname}-manpages-${rver}}\" \
    \"1a6f1e775dfe324a9b521793cbd2b3bba546442cc2ac2106d4df33dea9005038\"
}
"

eval "
function cwconfigure_${rname}() {
  pushd \"\$(cwbdir_${rname})\" &>/dev/null
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
        CPPFLAGS=\"\$(echo -I${cwsw}/{${rreqs// /,}}/current/include)\" \
        LDFLAGS=\"\$(echo -L${cwsw}/{${rreqs// /,}}/current/lib) -static -s\" \
        PKG_CONFIG_{LIBDIR,PATH}=\"\$(echo ${cwsw}/{${rreqs// /,}}/current/lib/pkgconfig | tr ' ' ':')\" \
        LIBS='-lcurl -latomic -lnghttp2 -lssh2 -lssl -lcrypto -lz'
  sed -i.ORIG 's/-lcurl/-lcurl -latomic -lnghttp2 -lssh2 -lssl -lcrypto -lz/g' Makefile
  : sed -i '/:.* build-unit-tests/s,build-unit-tests,,g' Makefile
  : sed -i '/:.* unit-tests/s,unit-tests,,g' Makefile
  grep -ril sys/poll\\.h \$(cwbdir_${rname})/ \
  | grep \\.h\$ \
  | xargs sed -i.ORIG 's#sys/poll\.h#poll.h#g'
  popd &>/dev/null
}
"
