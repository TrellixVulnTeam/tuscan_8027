# vim: set syntax=dockerfile:
# Copyright 2015 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Arch Linux container for getting all packages in groups base and
# base-devel.
#
# USAGE:
#   docker run container_name

FROM base/arch:latest
MAINTAINER Kareem Khazem <khazem@google.com>

# Make sure everything is up to date
RUN pacman-key --refresh-keys
RUN pacman -Syyu --needed --noconfirm
RUN pacman-db-upgrade

# Install needed software
RUN pacman -Syu --needed --noconfirm base-devel
RUN pacman -Syu --needed --noconfirm base
RUN pacman -Syu --needed --noconfirm python

RUN mkdir -p /build/packages

COPY get_fundamental_packages.py /build/get_fundamental_packages.py

# The following lines get sed-ed by Make, which replaces the values with
# your own username and group. Do not change these lines.
RUN groupadd --gid __GID __GROUP_NAME
RUN useradd  --uid __UID --gid __GID __USER_NAME

# So that you can access files after the container has been torn down
RUN chown -R __USER_NAME:__GROUP_NAME /build
USER __USER_NAME

ENTRYPOINT ["/usr/bin/python", "-u", "/build/get_fundamental_packages.py"]