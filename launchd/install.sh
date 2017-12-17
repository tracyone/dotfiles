#!/usr/bin/env bash
# install launchd script

cp *.plist ~/Library/LaunchAgents/

cp *.sh ~/Library/LaunchAgents/

launchctl load ~/Library/LaunchAgents/*.plist

launchctl start com.tracyone.launchctl.plist

launchctl list | grep tracyone
