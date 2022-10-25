#!/bin/sh


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
cp patches/0001-add-functionality-for-VITBTPLAY.patch imx-voiceui/vit/i.MX8M_A53/.
cd imx-voiceui/vit/i.MX8M_A53
git apply 0001-add-functionality-for-VITBTPLAY.patch
make clean
make -j8
echo "VIT compilation ended"
cd ../../..

#### PACK DEMO COMPONENTS ####

cp -a app/build/Btplayer ${BUILD_OUTPUT_DIR}
cp -a msgq/build/MsgQ ${BUILD_OUTPUT_DIR}
cp -a imx-voiceui/vit/i.MX8M_A53/build/btp_vit ${BUILD_OUTPUT_DIR}
cp -a sh/*.sh ${BUILD_OUTPUT_DIR}

#cd ..
tar zcvf ${BUILD_OUTPUT_DIR}.tgz ${BUILD_OUTPUT_DIR}
#cd 
