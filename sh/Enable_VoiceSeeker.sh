#/bin/sh

# Enable VoiceSeeker Audio Front-End #

# Copy asound.conf
cp -v /etc/asound.conf /etc/asound.conf_original
cp -v /opt/Btplayer/bin/asound.conf /etc

# Copy Config.ini file
cp -v /unit_tests/nxp-afe/Config.ini /unit_tests/nxp-afe/Config.ini_original
cp -v /opt/Btplayer/bin/Config.ini /unit_tests/nxp-afe

