k.PHONY: lint format test

lint:
	swiftlint

format:
	swift format -i -r .
	swiftlint --fix

test:
	swift test
