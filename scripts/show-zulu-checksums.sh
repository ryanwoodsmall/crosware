#!/usr/bin/env bash
#
# show checksums for given zulu jdk versions
# see also: https://github.com/ryanwoodsmall/shell-ish/blob/master/bin/show-latest-zulu.sh
# api: https://api.azul.com/metadata/v1/docs/swagger
#
set -euo pipefail

# prefix script name to passed args and echo it out
function scriptecho() {
  while [ ${#} -gt  0 ] ; do
    echo "$(basename -- ${BASH_SOURCE[0]}): ${1}"
    shift
  done
}

# fail with a message
function failexit() {
  scriptecho "${@}" 1>&2
  exit 1
}

# need at least one version to check
if [ ${#} -lt 1 ] ; then
  failexit "please provide at least one version to check"
fi

# we'll use curl and jq for our query/parsing needs
for p in curl jq ; do
  command -v ${p} &>/dev/null || failexit "${p} not found"
done

# curl options
: ${curl:="curl"}
: ${copts:="-k -L -s"}

# base url for package metadata
apiurl="https://api.azul.com/metadata/v1"
pkgurl="${apiurl}/zulu/packages"

# architectures and libcs we want
declare -a arches=( 'aarch64' 'aarch32hf' 'i686' 'x64' )
declare -a libcs=( 'linux-glibc' 'linux-musl' )

# query string stuff
declare -A qs
qs['archive_type']='tar.gz'
qs['java_package_type']='jdk'
qs['javafx_bundled']='false'
qs['release_status']='ga'
qs['availability_types']='ca'

# hashes to hold package ids, sha-256 sums, download urls, etc.
# encoded as {arch}:{libc}:{version}
declare -A packageids sha256sums urls pqs
while [ ${#} -gt 0 ] ; do
  v="${1}"
  shift
  for a in ${arches[@]} ; do
    for l in ${libcs[@]} ; do
      i="${a}:${l}:${v}"
      packageids["${i}"]=''
      sha256sums["${i}"]=''
      urls["${i}"]=''
      pqs["${i}"]=''
    done
  done
done

# generate {arch}:{libc}:{version} package query strings
for p in ${!packageids[@]} ; do
  a="${p%%:*}"
  v="${p##*:}"
  l="${p#${a}:}"
  l="${l%:${v}}"
  qs['arch']="${a}"
  qs['os']="${l}"
  qs['java_version']="${v}"
  pqs["${p}"]="$(for q in ${!qs[@]} ; do echo ${q}=${qs[${q}]} ; done | paste -s -d'&' -)"
done

# get a packageid for each {arch}:{libc}:{version}
for p in ${!packageids[@]} ; do
  packageids["${p}"]="$(eval "${curl} ${copts} '${pkgurl}/?${pqs[${p}]}'" | jq -r '.[]|.package_uuid' 2>/dev/null || true)"
done

# use the packageid to get the actual metadata (sha-256, dl url, ...)
for p in ${!packageids[@]} ; do
  test -z "${packageids[${p}]}" && continue || true
  # may have a multi-line value, just get the first one without any extra cruft
  i="$(echo ${packageids[${p}]} | head -1 | xargs echo | awk '{print $1}')"
  r="$(eval "${curl} ${copts} '${pkgurl}/${i}'" | jq -r '[.sha256_hash,.download_url]|@csv' 2>/dev/null || true)"
  r="${r//\"/}"
  sha256sums["${p}"]="${r%%,*}"
  urls["${p}"]="${r##*,}"
done

# dump info for each {arch}:{libc}:{version}
for p in ${!packageids[@]} ; do
  test -z "${packageids[${p}]}" && continue || true
  i=( $(echo ${p//:/ }) )
  # arch : libc : version : url : sha-256
  echo "${i[0]} : ${i[1]} : ${i[2]} : ${urls[${p}]} : ${sha256sums[${p}]}"
done | sort -t: -k2
