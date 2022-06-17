#!/bin/sh

# This script configures and runs VIT. #

# Load necessary kernel module
modprobe snd-aloop

# Run VoiceSpot and AFE
/opt/Btplayer/bin/VoiceSpot &
/opt/Btplayer/bin/afe libvoiceseekerlight &

# Run VIT
/opt/Btplayer/bin/btp_vit -ddefault -l ENGLISH
