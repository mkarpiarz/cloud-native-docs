#!/usr/bin/env bash

# <meta http-equiv="Refresh" content="0; url='https://docs.nvidia.com/dgx-systems/index.html'" />

BASEURL="https://docs.nvidia.com/datacenter/cloud-native"

while IFS= read -r line
do
  stripdotslash="${line:2}"       # container-toolkit/runtime/...
  docset="${stripdotslash%%/*}"   # container-toolkit
  rest="${stripdotslash#$docset}" # /runtime/...
  if [[ "${docset}" =~ ".html" ]]; then
    payload="<meta http-equiv=\"Refresh\" content=\"0; url='${BASEURL}/latest/${docset}'\" />"
  elif [[ "${rest}" =~ ^/archive ]]; then
    versioned="${rest#/archive/}"
    payload="<meta http-equiv=\"Refresh\" content=\"0; url='${BASEURL}/${docset}/${versioned}'\" />"
  else
    payload="<meta http-equiv=\"Refresh\" content=\"0; url='${BASEURL}/${docset}/latest${rest}'\" />"
  fi
  echo "${payload}" > "${line}"
done < <(cat files.txt)

