#!make

CTR_REGISTRY = cybwan
DOCKER_BUILDX_OUTPUT ?= type=registry

default: docker-build-alpine-jdk

.PHONY: docker-build-alpine-base
docker-build-alpine-base: DOCKER_BUILDX_PLATFORM=linux/amd64,linux/arm64
docker-build-alpine-base:
	docker buildx build --builder osm --platform=$(DOCKER_BUILDX_PLATFORM) -o $(DOCKER_BUILDX_OUTPUT) -t $(CTR_REGISTRY)/alpine-base:latest -f dockerfiles/Dockerfile.alpine-base .

jre-8u201-linux-amd64.tar.gz:
	axel -n5 https://repo.huaweicloud.com/java/jdk/8u201-b09/jdk-8u201-linux-x64.tar.gz
	tar zxf jdk-8u201-linux-x64.tar.gz
	cd jdk1.8.0_201 && \
	rm -rf jre/COPYRIGHT \
			   jre/LICENSE \
			   jre/README \
			   jre/release \
			   jre/THIRDPARTYLICENSEREADME-JAVAFX.txt \
			   jre/THIRDPARTYLICENSEREADME.txt \
			   jre/Welcome.html && \
	rm -rf jre/lib/plugin.jar \
			   jre/lib/ext/jfxrt.jar \
			   jre/bin/javaws \
			   jre/lib/javaws.jar \
			   jre/lib/desktop \
			   jre/plugin \
			   jre/lib/deploy* \
			   jre/lib/*javafx* \
			   jre/lib/*jfx* \
			   jre/lib/amd64/libdecora_sse.so \
			   jre/lib/amd64/libprism_*.so \
			   jre/lib/amd64/libfxplugins.so \
			   jre/lib/amd64/libglass.so \
			   jre/lib/amd64/libgstreamer-lite.so \
			   jre/lib/amd64/libjavafx*.so \
			   jre/lib/amd64/libjfx*.so && \
	cp bin/jps jre/bin/ && \
	cp lib/tools.jar jre/lib/ && \
	mv jre jre1.8.0_201 && \
	cd jre1.8.0_201/lib/amd64 && \
	ln -s server/libjvm.so libjvm.so
	cd jdk1.8.0_201 && tar zcf ../jre-8u201-linux-amd64.tar.gz jre1.8.0_201
	rm -rf jdk1.8.0_201 jdk-8u201-linux-x64.tar.gz

jre-8u201-linux-arm64.tar.gz:
	axel -n5 https://repo.huaweicloud.com/java/jdk/8u201-b09/jdk-8u201-linux-arm64-vfp-hflt.tar.gz
	tar zxf jdk-8u201-linux-arm64-vfp-hflt.tar.gz
	cd jdk1.8.0_201 && \
	rm -rf jre/COPYRIGHT \
			   jre/LICENSE \
			   jre/README \
			   jre/release \
			   jre/THIRDPARTYLICENSEREADME-JAVAFX.txt \
			   jre/THIRDPARTYLICENSEREADME.txt \
			   jre/Welcome.html && \
	rm -rf jre/lib/plugin.jar \
			   jre/lib/ext/jfxrt.jar \
			   jre/bin/javaws \
			   jre/lib/javaws.jar \
			   jre/lib/desktop \
			   jre/plugin \
			   jre/lib/deploy* \
			   jre/lib/*javafx* \
			   jre/lib/*jfx* && \
	cp bin/jps jre/bin/ && \
	cp lib/tools.jar jre/lib/ && \
	mv jre jre1.8.0_201 && \
	cd jre1.8.0_201/lib/aarch64 && \
	ln -s server/libjvm.so libjvm.so
	cd jdk1.8.0_201 && tar zcf ../jre-8u201-linux-arm64.tar.gz jre1.8.0_201
	rm -rf jdk1.8.0_201 jdk-8u201-linux-arm64-vfp-hflt.tar.gz

.PHONY: docker-build-alpine-jdk
docker-build-alpine-jdk: DOCKER_BUILDX_PLATFORM=linux/amd64,linux/arm64
docker-build-alpine-jdk: jre-8u201-linux-amd64.tar.gz jre-8u201-linux-arm64.tar.gz
	docker buildx build --builder osm --platform=$(DOCKER_BUILDX_PLATFORM) -o $(DOCKER_BUILDX_OUTPUT) -t $(CTR_REGISTRY)/alpine-jdk:latest -f dockerfiles/Dockerfile.alpine-jdk .