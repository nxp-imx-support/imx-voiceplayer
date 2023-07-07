# VIT Btplayer demo for  i.MX8M

The VIT BTPlayer demo application for i.MX8M is a Voice media player based in NXP Voice Intelligent Technology, a free library that provides a low power voice recognition technology, it integrates a complete audio front end / wake word engine / voice commands solution to control IOT devices

![alt text for screen readers](app/rsc/VITMediaplayer.png "VIT Media Player")

The application is based on QT Interface 6.2, Bluez 5.65 API for playing back audio and control the Bluetooth adapter.

### Build Instructions


### Step 1:
Setup your iMX8M SDK environment
```bash
source /opt/fsl-imx-internal-xwayland/6.1-langdale/environment-setup-armv8a-poky-linux
```
### Note:
It needs to set some variables before compiling (VOICE_UI, ASSETS, VOICE_UI_BRANCH, ASSETS_BRANCH).

VOICE_UI: Repository of voice_ui.

ASSETS: Repository of assets.

VOICE_UI_BRANCH: Branch name for voice_ui repository.

ASSETS_BRANCH: Branch name for assets repository.


Example:

export VOICE_UI=https://github.com/nxp-imx/imx-voiceui.git

export ASSETS=https://github.com/nxp-imx-support/nxp-demo-experience-assets.git

export VOICE_UI_BRANCH=MM_04.08.00_2305_L6.1.y

export ASSETS_BRANCH=lf-6.1.22_2.0.0

### Step 2: Run build script
This script will download app components, build and package the binary application in build_output_demo.tgz file
```bash
sh build-demo.sh
```

### Step 3: Install 
Copy build_output_demo.tgz directory to iMX8 Evk, extract its contents and run install.sh script in target
```bash
tar xvf build_output_demo.tgz
cd build_output_demo
sh install.sh

```

## Test the demo

### Run from binary
Login using root password and go to the installed directory and execute the init script to launch the player application
```bash
sh /home/root/.nxp-demo-experience/scripts/multimedia/btplayerdemo/init.sh
```

### Run from Demo Experience
Btplayer is also available from NXP demo experience under BT icon.


## Demo has been tested on:

| BOARD               | MACHINE           |
| ------------------- | ----------------- |
| i.MX 8M Plus (DDR4) | imx8mp-lpddr4-evk |
| i.MX 8M Mini (DDR4) | imx8mm-lpddr4-evk |

