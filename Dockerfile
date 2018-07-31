# Copyright 2018 JanusGraph Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        zlib1g-dev \
        rubygems \
        ruby-dev \
        sudo \
        zlib1g-dev \
    && gem install jekyll bundler

# Workaround for error when running 'bundle exec jekyll serve':
#
#     Invalid US-ASCII character "\xE2" on line 54
#
# as described in:
# https://github.com/mmistakes/minimal-mistakes/issues/1183#issuecomment-322790031
#
# Follows the solution as described here:
# https://github.com/mmistakes/minimal-mistakes/issues/1183#issuecomment-323544372
RUN apt-get install locales
RUN locale-gen en_US.UTF-8
RUN localedef -i en_US -f UTF-8 en_US.UTF-8

ENV USER janusgraph
ENV HOME /home/$USER

RUN useradd -ms /bin/bash $USER
# Enable passwordless `sudo` access for this user for debugging purposes.
RUN echo "janusgraph ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/janusgraph

WORKDIR $HOME
USER $USER
COPY Gemfile $HOME
RUN bundle install --path .bundle

RUN mkdir -p $HOME/website
VOLUME $HOME/website

# Continuation of the workaround from above for UTF-8 locale.
CMD LANG="en_US.UTF-8" LC_ALL="en_US.UTF-8" \
    bundle exec jekyll serve -H 0.0.0.0 --source website --incremental --watch
