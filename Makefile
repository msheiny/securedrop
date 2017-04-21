.PHONY: ci-spinup
ci-spinup:
	./devops/scripts/ci-spinup.sh

.PHONY: ci-teardown
ci-teardown:
	./devops/scripts/ci-teardown.sh

.PHONY: ci-runner
ci-run:
	./devops/scripts/ci-runner.sh

# Run SpinUP, Playbooks, and Testinfra
.PHONY: ci-go
ci-go:
	./devops/scripts/spin-run-test.sh
