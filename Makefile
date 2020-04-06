IMAGE_NAME = openshift-pgsql12-client:centos8

.PHONY: build
build:
	docker build --no-cache -t $(IMAGE_NAME) .
	docker tag openshift-pgsql12-client:centos8 quay.io/rhdevelopers/openshift-pgsql12-client:centos8
	docker tag openshift-pgsql12-client:centos8 quay.io/rhdevelopers/openshift-pgsql12-client:latest
	docker push quay.io/rhdevelopers/openshift-pgsql12-client:centos8
	docker push quay.io/rhdevelopers/openshift-pgsql12-client:latest