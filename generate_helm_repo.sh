#!/usr/bin/env bash

set -ex

# git clone https://github.com/magma/magma.git --depth 1
MAGMA_ROOT=/tmp/magma

mkdir -p charts
CHARTS_REPO=${PWD}/charts

MAGMA_CHARTS_REPO=https://shubhamtatvamasi.github.io/magma-charts-8-8-2022

if [ "${1}" == "lib" ]; then
  cp -r ${MAGMA_ROOT}/orc8r/cloud/helm/orc8rlib ${CHARTS_REPO}
else

  declare -A orc8r_helm_charts=( 
    [orc8r]="orc8r/cloud/helm/orc8r"
    [orc8rlib]="orc8r/cloud/helm/orc8rlib"
    [lte-orc8r]="lte/cloud/helm/lte-orc8r"
    [feg-orc8r]="feg/cloud/helm/feg-orc8r"
    [cwf-orc8r]="cwf/cloud/helm/cwf-orc8r"
    [secrets]="orc8r/cloud/helm/orc8r/charts/secrets"
    [domain-proxy]="dp/cloud/helm/dp/charts/domain-proxy"
  )

  for orc8r_chart in "${orc8r_helm_charts[@]}"
  do
    cp -r ${MAGMA_ROOT}/${orc8r_chart} ${CHARTS_REPO}
  done

  # Delete Chart.lock files
  find ${CHARTS_REPO} -type f -name 'Chart.lock' -delete

  # git checkout charts/orc8rlib/Chart.yaml
fi

# Replace orc8rlib repo link
find ${CHARTS_REPO} -maxdepth 2 -type f -name 'Chart.yaml' -exec \
  yq e '(.dependencies[] | select(.name == "orc8rlib") | .repository) = "${MAGMA_CHARTS_REPO}"' -i {} \;


# rm -rf cwf-orc8r feg-orc8r lte-orc8r orc8r secrets
