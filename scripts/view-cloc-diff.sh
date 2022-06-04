#!/usr/bin/env bash
#
# show the differnces between runs of ${cwtop}/scripts/crosware-cloc-source.sh
#

vim <(diff -Naur ${cwtop}/tmp/crosware.set.out{.old,} | egrep -v -- '^(-|\+| )(cw.*=\(|(PATH|PKG_CONFIG_(LIBDIR|PATH)|(C(|XX|PP)|LD)FLAGS)=)')
