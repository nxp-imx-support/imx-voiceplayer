# Message-Queue Commands Sender Test Application

The sendMessageQ is a simple application that can send messages to test the
DisplayCards application. The DisplayCards is always listening to the MessageQ
channel opened by te sendMessageQ test application.

## Valid messages

All messages are valid.

## Examples of usage

    ./msgq message

## Build instructions

- Set up your toolchain

```bash
    source /opt/fsl-imx-xwayland/5.15-honister/environment-setup-cortexa53-crypto-poky-linux
```

- Create a build directory

```bash
    mkdir build
    cd build
```

- Run the cmake

```bash
    cmake ../
    make
```

The output file should be the msgq executable 

