BASE_IMAGE_NAME=s2i-wordpress
NAMESPACE=bonniernews
# https://wordpress.org/download/release-archive/
VERSIONS = \
4.5.8:cf4b0a36f82f942696abb17cb48719e4fa256722 \
4.6.5:b73d8a86bbea77e5045157ac7a7d65502cd910bc \
4.7.4:153592ccbb838cafa1220de9174ec965df2e9e1a

include build/common.mk