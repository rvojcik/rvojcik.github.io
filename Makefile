# For development
#
IMAGE_NAME = localjekyll
CURR_DIR = $(shell pwd)

build:
	docker build -t $(IMAGE_NAME) ./

docker-run-autobuild: build
	docker run --rm --volume="$(CURR_DIR):/srv/jekyll:Z" --publish 4000:4000 $(IMAGE_NAME) jekyll serve --trace
