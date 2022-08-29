IMAGE=gstrtoint/glpi:1.0

.PHONY: all build

all: build

build:
	docker build --rm -t $(IMAGE) .
