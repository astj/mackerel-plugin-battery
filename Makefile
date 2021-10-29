BIN := mackerel-plugin-battery
VERSION := $$(make -s show-version)
GOBIN ?= $(shell go env GOPATH)/bin
export GO111MODULE=on

.PHONY: all
all: build

.PHONY: build
build:
	go build -o $(BIN) .

.PHONY: install
install:
	go install ./...

.PHONY: show-version
show-version:
	@cat VERSION

.PHONY: cross
cross: $(GOBIN)/goxz
	goxz -n $(BIN) -pv=v$(VERSION)

$(GOBIN)/goxz:
	go install github.com/Songmu/goxz/cmd/goxz@latest

.PHONY: test
test: build
	go test -v ./...

.PHONY: lint
lint: $(GOBIN)/golint
	go vet ./...
	golint -set_exit_status ./...

$(GOBIN)/golint:
	go install golang.org/x/lint/golint@latest

.PHONY: clean
clean:
	rm -rf $(BIN) goxz
	go clean

.PHONY: upload
upload: $(GOBIN)/ghr
	ghr "v$(VERSION)" goxz

$(GOBIN)/ghr:
	go install github.com/tcnksm/ghr@latest
