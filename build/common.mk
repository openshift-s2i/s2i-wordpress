build = build/build.sh

script_env = \
	VERSIONS="$(VERSIONS)"                            \
	OS="$(OS)"                                        \
	NAMESPACE="$(NAMESPACE)"                          \
	BASE_IMAGE_NAME="$(BASE_IMAGE_NAME)"              \
	VERSION="$(VERSION)"

.PHONY: build
build:
	$(script_env) $(build)

.PHONY: all
all:
	build