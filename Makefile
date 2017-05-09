BASE_IMAGE_NAME=s2i-wordpress
NAMESPACE=bonniernews
# https://wordpress.org/download/release-archive/
VERSIONS = \
4.5.6:3dfde5aaff1813f8205c796aae49a1fd3a18ae93 \
4.6.3:5643e83932d60df516411a0f21663fb4504d9b93 \
4.7.4:153592ccbb838cafa1220de9174ec965df2e9e1a

include build/common.mk