PROJECT := StreamingDepthDataFromTheTrueDepthCamera/TrueDepthStreamer.xcodeproj
SCHEME := TrueDepthStreamer
DERIVED_DATA ?= /tmp/TrueDepthBuild
IOS_SIMULATOR_DESTINATION ?= platform=iOS Simulator,name=iPhone 16

.PHONY: build test test-build ci docs

build:
	./scripts/ci/build_ios.sh

test:
	IOS_SIMULATOR_DESTINATION="$(IOS_SIMULATOR_DESTINATION)" ./scripts/ci/test_ios.sh

test-build:
	./scripts/ci/build_for_testing_ios.sh

ci: build test

docs:
	@echo "Documentation entry points:"
	@echo "  README.md"
	@echo "  docs/ARCHITECTURE.md"
	@echo "  docs/REPOSITORY.md"
	@echo "  docs/TESTING.md"
	@echo "  docs/CI.md"
