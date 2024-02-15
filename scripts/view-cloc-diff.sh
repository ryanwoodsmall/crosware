#!/usr/bin/env bash
#
# show the differnces between runs of ${cwtop}/scripts/crosware-cloc-source.sh
#
# XXX - you _really_ want diffutils diff here. busybox is slowww...
# XXX - edit with 'vim -u NONE' or else the modeline injected will be processed and error
#

vim <(diff -Naur ${cwtop}/tmp/crosware.set.out{.old,} | egrep -v -- '^(-|\+| )(cw.*=\(|(LS_COLORS|PATH|PKG_CONFIG_(LIBDIR|PATH)|(C(|XX|PP)|LD)FLAGS)=)' ; echo '# vim: ft=diff:' )
