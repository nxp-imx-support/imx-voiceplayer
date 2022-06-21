#/bin/sh

# Enable VoiceSeeker Audio Front-End #

# Copy asound.conf
cp -v /etc/asound.conf /etc/asound.conf_original
cp -v /opt/Btplayer/bin/asound.conf /etc

# Copy Voiceseekerlight library
cp -v /opt/Btplayer/bin/libvoiceseekerlight.so.1.0 /usr/lib/nxp-afe
ln -s libvoiceseekerlight.so.1.0 /usr/lib/nxp-afe/libvoiceseekerlight.so

# Copy Config.ini file
cp -v /opt/Btplayer/bin/Config.ini /unit_tests/nxp-afe

# Copy NXP binaries
cp -v /opt/Btplayer/bin/HeyNXP_en-US_1.bin /unit_tests/nxp-afe
cp -v /opt/Btplayer/bin/HeyNXP_1_params.bin /unit_tests/nxp-afe 
