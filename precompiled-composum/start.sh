#!/usr/bin/env zsh
###############################################################################
#    Licensed to the Apache Software Foundation (ASF) under one               #
#    or more contributor license agreements.  See the NOTICE file             #
#    distributed with this work for additional information                    #
#    regarding copyright ownership.  The ASF licenses this file               #
#    to you under the Apache License, Version 2.0 (the                        #
#    "License"); you may not use this file except in compliance               #
#    with the License.  You may obtain a copy of the License at               #
#                                                                             #
#    http://www.apache.org/licenses/LICENSE-2.0                               #
#                                                                             #
#    Unless required by applicable law or agreed to in writing,               #
#    software distributed under the License is distributed on an              #
#    "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY                   #
#    KIND, either express or implied.  See the License for the                #
#    specific language governing permissions and limitations                  #
#    under the License.                                                       #
###############################################################################

chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
chome_window_size="960,1080"
ACTIVE_FEATURES=("composum" "composum-precompiled")
LAUNCHER="sling-feature/target/dependency/org.apache.sling.feature.launcher.jar"
trap ctrl_c SIGINT

declare -A FEATURES
FEATURES[composum.port]="8080"
FEATURES[composum.launcher.home]="sling-feature/target/composum"
FEATURES[composum.launcher.cache]="${FEATURES[composum.launcher.home]}-cache"
FEATURES[composum.mvn]="mvn:org.apache.sling/org.apache.sling.composum-starter-demo/12-SNAPSHOT/slingosgifeature/composum"
FEATURES[composum.url]="http://localhost:${FEATURES[composum.port]}/starter.html"
FEATURES[composum.chrome.window.position]="0,0"
FEATURES[composum.chrome.profile]="${FEATURES[composum.launcher.home]}-chrome"
FEATURES[composum.pid]=""

FEATURES[composum-precompiled.port]="8081"
FEATURES[composum-precompiled.launcher.home]="sling-feature/target/composum-precompiled"
FEATURES[composum-precompiled.launcher.cache]="${FEATURES[composum-precompiled.launcher.home]}-cache"
FEATURES[composum-precompiled.mvn]="mvn:org.apache.sling/org.apache.sling.composum-starter-demo/12-SNAPSHOT/slingosgifeature/composum-precompiled"
FEATURES[composum-precompiled.url]="http://localhost:${FEATURES[composum-precompiled.port]}/starter.html"
FEATURES[composum-precompiled.chrome.window.position]="960,0"
FEATURES[composum-precompiled.chrome.profile]="${FEATURES[composum-precompiled.launcher.home]}-chrome"
FEATURES[composum-precompiled.pid]=""


START=`date +%s`

function ctrl_c() {
    echo
    for feature in ${ACTIVE_FEATURES}; do
        kill_pid "${FEATURES[${feature}.pid]}"
    done
    info "☑️  Done."
    exit
}

function kill_pid() {
    local PID=$1
    if [[ -n ${PID} ]]; then
        info "🚦 Stopping process ${PID}..."
        kill -15 ${PID}
        if [[ $? -ne 0 ]]; then
            info "🛑 Process ${PID} seems to have already been killed."
        else
            while kill -0 ${PID} 2> /dev/null; do
                sleep 1
            done
        fi
        info "🛑 Stopped process ${PID}."
    fi
}

function open_browser() {
    local URL="$1"
    local WINDOW="$2"
    local WINDOW_POSITION="$3"
    local CHROME_DIR="$4"
    local READY=1
    info "⏳ Waiting for ${URL} to be ready..."
    while [[ ${READY} -ne 0 ]]; do
        curl -s ${URL} | grep -q "Do not remove this comment, used for Starter integration tests"
        READY=$?
        sleep 1
    done
    info "🖥  Opening ${URL} in Chrome."
    ${chrome} \
        --no-first-run \
        --bwsi \
        --user-data-dir="${CHROME_DIR}" \
        --window-size="${WINDOW}" \
        --window-position="${WINDOW_POSITION}" \
        "${URL}" &
}

function log() {
    local LEVEL="${1}"
    local MESSAGE="${@:2}"
    local NOW=`date +%s`
    printf "[%4s][%7s] - %s\n" "$(( NOW - START))" "${LEVEL}" "${MESSAGE}"
}

function info() {
    log "INFO" "${@}"
}

function error() {
    log "ERROR" "${@}"
}


if [[ -f ${LAUNCHER} ]]; then
    for feature in ${ACTIVE_FEATURES}; do
        java    -jar ${LAUNCHER} \
                -p ${FEATURES[${feature}.launcher.home]} \
                -c ${FEATURES[${feature}.launcher.cache]} \
                -f ${FEATURES[${feature}.mvn]} \
                -D "org.osgi.service.http.port=${FEATURES[${feature}.port]}" > ${FEATURES[${feature}.launcher.home]}.log 2>&1 &
        
        FEATURES[${feature}.pid]=$!

        info "🎬 Started Composum - PID=${FEATURES[${feature}.pid]}."
        open_browser \
            "${FEATURES[${feature}.url]}" \
            "${chome_window_size}" \
            "${FEATURES[${feature}.chrome.window.position]}" \
            "${FEATURES[${feature}.chrome.profile]}" &
    done
else
    error "🙊 Did you forget to build the features?"
fi


wait
