#!/bin/sh

# Copyright 2022-2023 NXP
# SPDX-License-Identifier: BSD-3-Clause

if [ "$1" != "" ]; then
      BUILD_TYPE=$1
    else
      BUILD_TYPE=demo
fi


BUILD_OUTPUT_DIR=build_output_${BUILD_TYPE}
iMX8M_DIR=i.MX8M_A53
iMX9X_DIR=i.MX9X_A55

rm -rfv  ${BUILD_OUTPUT_DIR}.tgz ${BUILD_OUTPUT_DIR}
mkdir -p ${BUILD_OUTPUT_DIR}
mkdir -p ${BUILD_OUTPUT_DIR}/${iMX8M_DIR}
mkdir -p ${BUILD_OUTPUT_DIR}/${iMX9X_DIR}

#### BUILD APP GUI ####

rm -rf app/build
mkdir -p app/build
cd app/build

qmake ../Btplayer.pro 

make -j8
cd ../..


#### BUILD APP COMPONENTS ####

rm -rf msgq/build 
mkdir -p msgq/build 
cd msgq/build

cmake ..
make -j8
cd ../..

#### BUILD VOICE_UI AND VOICE ACTION COMPONENTS ####

echo "VIT compilation start"
git clone ${VOICE_UI} --branch ${VOICE_UI_BRANCH}
git clone ${ASSETS} -b ${ASSETS_BRANCH}
rm imx-voiceui/vit/i.MX8M_A53/Lib/VIT_Model_en.h
rm imx-voiceui/vit/i.MX9X_A55/Lib/VIT_Model_en.h
cp nxp-demo-experience-assets/build/demo-experience-voice-demo-bt-player/VIT_Model_en.h imx-voiceui/vit/i.MX8M_A53/Lib/.
cp nxp-demo-experience-assets/build/demo-experience-voice-demo-bt-player/VIT_Model_en.h imx-voiceui/vit/i.MX9X_A55/Lib/.
cd imx-voiceui 
make clean
make -j8
cd ..
cd voiceAction
make clean
make -j8
cd ..
echo "VIT compilation ended"

#### PACK DEMO COMPONENTS ####

cp -a app/build/Btplayer ${BUILD_OUTPUT_DIR}
cp -a app/rsc/bluetooth.svg ${BUILD_OUTPUT_DIR}
cp -a msgq/build/MsgQ ${BUILD_OUTPUT_DIR}
cp -a imx-voiceui/release/voice_ui_app ${BUILD_OUTPUT_DIR}/${iMX8M_DIR}
cp -a imx-voiceui/release/libvoiceseekerlight.so.2.0 ${BUILD_OUTPUT_DIR}
cp -a imx-voiceui/release/HeyNXP_1_params.bin ${BUILD_OUTPUT_DIR}
cp -a imx-voiceui/release/HeyNXP_en-US_1.bin ${BUILD_OUTPUT_DIR}
cp -a voiceAction/build/btp ${BUILD_OUTPUT_DIR}
cp -a voiceAction/bridgeVoiceUI/WakeWordNotify ${BUILD_OUTPUT_DIR}
cp -a voiceAction/bridgeVoiceUI/WWCommandNotify ${BUILD_OUTPUT_DIR}
cp -a scripts/install.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/demos.json ${BUILD_OUTPUT_DIR}
cp -a scripts/init.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/stop.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/bt-init.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/connect.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/volume.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/Config.ini ${BUILD_OUTPUT_DIR}
cp -a scripts/Enable_VoiceSeeker.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/Restore_VoiceSeeker.sh ${BUILD_OUTPUT_DIR}

#cd ..
tar zcvf ${BUILD_OUTPUT_DIR}.tgz ${BUILD_OUTPUT_DIR}
#cd 
