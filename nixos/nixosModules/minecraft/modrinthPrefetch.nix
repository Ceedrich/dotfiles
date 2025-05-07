{ loader
, game_version

, writeShellScriptBin
, curl
, jq
, gnused
}:

writeShellScriptBin "modrinth-prefetch" ''
  MODRINTH_API="https://api.modrinth.com/v2"

  declare -A seen_ids # ids

  generatePrefetch () {
    version=$1
    id=$(echo $version | ${jq}/bin/jq -r '.project_id' )

    echo -n "$id = "
    echo $version \
    | ${jq}/bin/jq -c '.files | (.[] | select(.primary == true)) // .[0]  | {url: .url, sha512: .hashes.sha512}' \
    | ${gnused}/bin/sed 's/{"url":"\(.\+\)","sha512":"\(.\+\)"}/fetchurl { url = "\1"; sha512 = "\2"; };/'
  }

  fetch_mod() {
    local identifier="$1"

    if [[ -n "''\${seen_ids[$identifier]+x}" ]]; then
      return
    fi

    version=$(${curl}/bin/curl -s "$MODRINTH_API/project/$identifier/version?loaders=%5B%22${loader}%22%5D&game_versions=%5B%22${game_version}%22%5D" | jq '.[0]')
  
    if [[ "$version" == "null" ]]; then
      echo "WARNING: No compatible version found for $identifier" >&2
      return
    fi
    project_id=$(echo $version | ${jq}/bin/jq -r '.project_id')

    if [[ -n "''${seen_ids[$project_id]+x}" ]]; then
      return
    fi

    seen_ids[$project_id]=1

    generatePrefetch "$version"

    # Dependencies

    deps=$(echo "$version" | ${jq}/bin/jq -r '.dependencies[] | select(.dependency_type == "required") | .project_id')

    for dep_id in $deps; do
      fetch_mod "$dep_id"
    done
  }


  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [slug1 slug2 ...]"
    exit 1
  fi

  echo "{ fetchurl } : {"
  for mod in "$@"; do
    fetch_mod "$mod"
  done
  echo "}"
''
