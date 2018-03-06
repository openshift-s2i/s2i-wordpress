BASE_IMAGE_NAME=s2i-wordpress
NAMESPACE=bonniernews
# https://wordpress.org/download/release-archive/
VERSIONS = \
4.7.9:dbcc2b76d10c8c05d50ef6be2698d15eb3d76dcc \
4.9.4:0e630bf940fd586b10e099cd9195b3e825fb194c

include build/common.mk

# Deprecated
#4.5.8:cf4b0a36f82f942696abb17cb48719e4fa256722 \
#4.6.5:b73d8a86bbea77e5045157ac7a7d65502cd910bc \
#4.7.4:153592ccbb838cafa1220de9174ec965df2e9e1a \