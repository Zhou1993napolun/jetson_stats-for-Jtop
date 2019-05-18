#!/usr/bin/env python
# -*- coding: UTF-8 -*-
# Copyright (C) 2018, Raffaello Bonghi <raffaello@rnext.it>
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
# 1. Redistributions of source code must retain the above copyright 
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. Neither the name of the copyright holder nor the names of its 
#    contributors may be used to endorse or promote products derived 
#    from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
# BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Reference:
# 1. https://packaging.python.org
# 2. https://julien.danjou.info/starting-your-first-python-project/
# 3. https://medium.com/@trstringer/the-easy-and-nice-way-to-do-cli-apps-in-python-5d9964dc950d
# 4. https://chriswarrick.com/blog/2014/09/15/python-apps-the-right-way-entry_points-and-scripts/
# 5. https://python-packaging.readthedocs.io
# 6. https://github.com/pypa/sampleproject
# 7. https://pypi.org/classifiers/

import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="jtop",
    version="1.6.0",
    author="Raffaello Bonghi",
    author_email="raffaello@rnext.it",
    description="Interactive system-monitor process viewer for nvidia Jetson Nano, AGX Xavier, TX2, TX1",
    license='LICENSE',
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/rbonghi/jetson_stats",
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 2.7",
        "License :: OSI Approved :: MIT License",
        "Operating System :: POSIX :: Linux", 
        "Topic :: Software Development :: Embedded Systems",
        "Topic :: Software Development :: Debuggers", 
        "Topic :: Software Development :: Libraries",
        "Topic :: Software Development :: User Interfaces",
        "Topic :: System :: Hardware",
        "Topic :: System :: Logging",
        "Topic :: System :: Monitoring",
        "Topic :: System :: Operating System",
        "Topic :: System :: Operating System Kernels",
        "Topic :: System :: Shells",
        "Topic :: System :: Systems Administration",
        "Topic :: Terminals",
        ],
    # Add jetson_variables in /opt/jetson_stats
    # http://docs.python.org/3.4/distutils/setupscript.html#installing-additional-files
    data_files=[('/opt/jetson_stats', ['scripts/jetson_variables', 
                                       'scripts/jetson-performance.sh']),
                ('/etc/profile.d', ['scripts/jetson_env.sh']),
               ],
    # Install extra scripts
    scripts=['scripts/jetson-docker', 
             'scripts/jetson-swap',
             'scripts/jetson-release', 
            ],
    # The following provide a command called `jtop`
    entry_points={
        'console_scripts': [ 'jtop=jtop.__main__:main' ],
    },
)
#EOF