BASE_IMAGE_NAME=s2i-wordpress
NAMESPACE=bonniernews
# https://wordpress.org/download/release-archive/
VERSIONS = \
4.5.6:3dfde5aaff1813f8205c796aae49a1fd3a18ae93 \
4.6.3:5643e83932d60df516411a0f21663fb4504d9b93 \
4.7.2:7b687f1af589c337124e6247229af209ec1d52c3

include build/common.mk