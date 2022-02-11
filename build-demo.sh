#!/bin/sh

# Copyright 2022 NXP                                                                                                                                                                                                                                                                            
# SPDX-License-Identifier: BSD-3-Clause

if [ "$1" != "" ]; then
      BUILD_TYPE=$1
    else
      BUILD_TYPE=demo
fi


BUILD_OUTPUT_DIR=build_output_${BUILD_TYPE}

rm -rfv  ${BUILD_OUTPUT_DIR}.tgz ${BUILD_OUTPUT_DIR}
mkdir -p ${BUILD_OUTPUT_DIR}


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

echo "VIT compilation start"
git clone https://github.com/nxp-imx/imx-voiceui.git -b MM_04.07.02_2210_L5.15.y
cp patches/0001-add-functionality-for-VITBTPLAY.patch imx-voiceui/vit/i.MX8M_A53/.                               
cp patches/0001-update-VIT-lib.patch imx-voiceui/vit/i.MX8M_A53/.
cd imx-voiceui/vit/i.MX8M_A53
git apply 0001-add-functionality-for-VITBTPLAY.patch
git apply 0001-update-VIT-lib.patch
make clean
make -j8
echo "VIT compilation ended"
cd ../../..

#### PACK DEMO COMPONENTS ####

cp -a app/build/Btplayer ${BUILD_OUTPUT_DIR}
cp -a app/rsc/bluetooth.svg ${BUILD_OUTPUT_DIR}
cp -a msgq/build/MsgQ ${BUILD_OUTPUT_DIR}
cp -a imx-voiceui/vit/i.MX8M_A53/build/btp_vit ${BUILD_OUTPUT_DIR}
cp -a scripts/install.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/demos.json ${BUILD_OUTPUT_DIR}
cp -a scripts/init.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/bt-init.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/connect.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/volume.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/asound.conf ${BUILD_OUTPUT_DIR}
cp -a scripts/Config.ini ${BUILD_OUTPUT_DIR}
cp -a scripts/Enable_VoiceSeeker.sh ${BUILD_OUTPUT_DIR}
cp -a scripts/Restore_VoiceSeeker.sh ${BUILD_OUTPUT_DIR}

#cd ..
tar zcvf ${BUILD_OUTPUT_DIR}.tgz ${BUILD_OUTPUT_DIR}
#cd 
