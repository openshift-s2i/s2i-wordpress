build = build/build.sh
push = build/push.sh

script_env = \
	VERSIONS="$(VERSIONS)"                            \
	OS="$(OS)"                                        \
	NAMESPACE="$(NAMESPACE)"                          \
	BASE_IMAGE_NAME="$(BASE_IMAGE_NAME)"              \
	VERSION="$(VERSION)"

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: push
push:
	$(script_env) $(push)

.PHONY: all
all:
	build
	push