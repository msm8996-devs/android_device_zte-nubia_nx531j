#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2019 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

# Required!
export DEVICE=nx531j
export DEVICE_COMMON=msm8996-common
export VENDOR=zte-nubia

export DEVICE_BRINGUP_YEAR=2016

function blob_fixup() {
    case "${1}" in
    vendor/bin/imsrcsd)
        patchelf --add-needed "libbase_shim.so" "${2}"
        ;;

    # Patch RIL blobs for VNDK
    vendor/lib64/lib-dplmedia.so)
        patchelf --remove-needed "libmedia.so" "${2}"
        ;;
        
    # Patch Camera blobs for VNDK
    vendor/lib/libmmcamera2_stats_modules.so)
        sed -i "s|libgui.so|libfui.so|g" "${2}"
        sed -i "s|libandroid.so|libcamshim.so|g" "${2}"
        ;;

    # Patch Camera blobs for VNDK
    vendor/lib/libmmcamera_ppeiscore.so)
        sed -i "s|libgui.so|libfui.so|g" "${2}"
        ;;

    # Patch Camera blobs for VNDK
    vendor/lib/libmpbase.so)
        patchelf --remove-needed "libandroid.so" "${2}"
        ;;
    esac
}

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
