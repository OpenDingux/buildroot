DOCKER_TAG_REVISION := $(or $(DOCKER_TAG_REVISION),$(shell git rev-parse HEAD 2> /dev/null || true))
DOCKER_TAG_DATE := $(or 		\
	$(DOCKER_TAG_DATE),				\
	$(shell (git log -1 --format="%at" 2> /dev/null || true) | xargs -I{} date -d @{} +%Y%m%d))

CONFIGS=gcw0 rs90
CONFIG_IMAGES=$(addsuffix -docker-image, $(CONFIGS))

.PHONY: publish-docker-images $(CONFIG_IMAGES) $(addprefix push-, $(CONFIG_IMAGES)) $(addprefix publish-, $(CONFIG_IMAGES)) docker-image push-docker-image

publish-docker-images: $(addprefix publish-, $(CONFIG_IMAGES))

$(CONFIG_IMAGES): %-docker-image:
	make docker-image DOCKER_CONFIG=$*

$(addprefix push-, $(CONFIG_IMAGES)): push-%-docker-image:
	make push-docker-image DOCKER_CONFIG=$*

$(addprefix publish-, $(CONFIG_IMAGES)): publish-%-docker-image:
	$(MAKE) $*-docker-image push-$*-docker-image

docker-image:
	test -n "$(DOCKER_CONFIG)"  # $$DOCKER_CONFIG
	test -n "$(DOCKER_IMAGE)"  # $$DOCKER_IMAGE
	docker build \
		-t ${DOCKER_IMAGE}:${DOCKER_CONFIG}-${DOCKER_TAG_REVISION} \
		-t ${DOCKER_IMAGE}:${DOCKER_CONFIG}-${DOCKER_TAG_DATE} \
		-t ${DOCKER_IMAGE}:${DOCKER_CONFIG}-latest \
		--build-arg CONFIG=${DOCKER_CONFIG} .

push-docker-image:
	test -n "$(DOCKER_CONFIG)"  # $$DOCKER_CONFIG
	test -n "$(DOCKER_IMAGE)"  # $$DOCKER_IMAGE
	docker push ${DOCKER_IMAGE}:${DOCKER_CONFIG}-${DOCKER_TAG_REVISION}
	docker push ${DOCKER_IMAGE}:${DOCKER_CONFIG}-${DOCKER_TAG_DATE}
	docker push ${DOCKER_IMAGE}:${DOCKER_CONFIG}-latest
