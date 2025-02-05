#!/usr/bin/python3
#
# Autoinstall using sudo crontab -e and add
# @reboot sleep 10; /usr/bin/python3 <path/to/upgrade-discord.py>
#

import os
import requests
import re
import tempfile
import subprocess


DISCORD_URL = "https://discord.com/api/download?platform=linux&format=deb"
PACKAGE = "discord"

def parse_version(version):
    splits = version.split(".")
    if len(splits) != 3:
        raise Exception(f"Failed to parse '{version}' as version")

    return (int(splits[0]), int(splits[1]), int(splits[2]))

def local_version():
    result = subprocess.run(
            ["apt-cache", "show", "discord"],
            capture_output = True,
            text = True
    )

    match = re.search("Version: (.*)", result.stdout)
    if match is None or match.group(1) is None:
        return (0, 0, 0)

    return parse_version(match.group(1))

def remote_version():
    res = requests.head(DISCORD_URL, allow_redirects=False)
    loc = res.headers["location"]
    match = re.search("discord-(.*)\.deb", loc)
    return parse_version(match.group(1))

local = local_version()
remote = remote_version()

if local < remote:
    res = requests.get(DISCORD_URL, allow_redirects=True)
    with tempfile.NamedTemporaryFile(suffix=".deb") as fp:
        fp.write(res.content)
        subprocess.run(['apt-get', 'install', fp.name])
