# Copyright 2017 JanusGraph Authors
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

VERB = @
ifeq ($(VERBOSE),1)
	VERB =
endif

.PHONY default:
	$(VERB) echo "Available targets: build, run"

JEKYLL_IMAGE = janusgraph-jekyll
JEKYLL_HOST_PORT = 4000
JEKYLL_SERVER_PORT = 4000

build:
	$(VERB) docker build . -t $(JEKYLL_IMAGE)

# Workaround for https://github.com/jekyll/jekyll/issues/4268 (env vars)
run:
	$(VERB) docker run -v $$(pwd):/home/janusgraph/website \
	    -p $(JEKYLL_HOST_PORT):$(JEKYLL_SERVER_PORT) \
	    -it $(JEKYLL_IMAGE)
