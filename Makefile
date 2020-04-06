IMAGE_NAME = rhdevelopers/openshift-pgsql12-primary:centos7-clients

.PHONY: build
build:
	docker build --no-cache -t $(IMAGE_NAME) .
	docker tag rhdevelopers/openshift-pgsql12-primary:centos7-clients quay.io/rhdevelopers/openshift-pgsql12-client:centos8
	# docker push quay.io/rhdevelopersopenshift-pgsql12-primary:centos7-clients