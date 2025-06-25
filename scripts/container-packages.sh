#!/usr/bin/env bash
#
# these are the base recipes installed as part of the container build
#
set -eu
set -o pipefail

declare -a container_recipes
container_recipes+=( '9base' )
container_recipes+=( 'ag' )
container_recipes+=( 'alpinemuslutils' )
container_recipes+=( 'bash' )
container_recipes+=( 'bearssl' )
container_recipes+=( 'bim' )
container_recipes+=( 'bootstrapmake' )
container_recipes+=( 'busybox' )
container_recipes+=( 'cacertificates' )
container_recipes+=( 'cryanc' )
container_recipes+=( 'curlmbedtls' )
container_recipes+=( 'dropbear' )
container_recipes+=( 'elvis' )
container_recipes+=( 'entr' )
container_recipes+=( 'gettexttiny' )
container_recipes+=( 'htermutils' )
container_recipes+=( 'jo' )
container_recipes+=( 'jq' )
container_recipes+=( 'less' )
container_recipes+=( 'mbedtls' )
#container_recipes+=( 'mujs' )
container_recipes+=( 'neatvi' )
container_recipes+=( 'otools' )
container_recipes+=( 'outils' )
container_recipes+=( 'pkgconf' )
container_recipes+=( 'plan9port9p' )
container_recipes+=( 'pv' )
container_recipes+=( 'px5g' )
container_recipes+=( 'rlwrap' )
container_recipes+=( 'rsyncminimal' )
container_recipes+=( 'sbase' )
container_recipes+=( 'shellish' )
container_recipes+=( 'tini' )
container_recipes+=( 'tinyscheme' )
container_recipes+=( 'toybox' )
container_recipes+=( 'u9fs' )
container_recipes+=( 'ubase' )
container_recipes+=( 'unzip' )
container_recipes+=( 'x509cert' )
container_recipes+=( 'zip' )

for (( i=0; i<${#container_recipes[@]}; i++ )) ; do
  echo "${container_recipes[${i}]}"
done | paste -s -d' ' -
