.PHONY: ci-spinup
ci-spinup:
	./devops/scripts/ci-spinup.sh

.PHONY: ci-teardown
ci-teardown:
	./devops/scripts/ci-teardown.sh

.PHONY: ci-run
ci-run:
	./devops/scripts/ci-runner.sh
