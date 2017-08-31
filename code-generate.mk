OUTPUT         := _output
OUTPUT_BASE    := $(GOPATH)/src 
INPUT_BASE     := github.com/sapcc/kubernikus
API_BASE       := $(INPUT_BASE)/pkg/apis
GENERATED_BASE := $(INPUT_BASE)/pkg/generated
BIN            := $(OUTPUT)/bin

client-gen: $(OUTPUT)/bin/client-gen
	@rm -rf ./pkg/generated/clientset
	@mkdir -p ./pkg/generated/clientset
	$(BIN)/client-gen \
	  --go-header-file /dev/null \
	  --output-base $(OUTPUT_BASE) \
	  --input-base $(API_BASE) \
	  --clientset-path $(GENERATED_BASE) \
	  --input kubernikus/v1 \
	  --clientset-name clientset 

informer-gen: $(OUTPUT)/bin/informer-gen
	@rm -rf ./pkg/generated/informers
	@mkdir -p ./pkg/generated/informers
	$(BIN)/informer-gen \
	  --logtostderr \
	  --go-header-file /dev/null \
	  --output-base                 $(OUTPUT_BASE) \
	  --input-dirs                  $(API_BASE)/kubernikus/v1  \
	  --output-package              $(GENERATED_BASE)/informers \
	  --listers-package             $(GENERATED_BASE)/listers   \
	  --internal-clientset-package  $(GENERATED_BASE)/clientset \
	  --versioned-clientset-package $(GENERATED_BASE)/clientset 

lister-gen: $(OUTPUT)/bin/lister-gen
	@rm -rf ./pkg/generated/listers
	@mkdir -p ./pkg/generated/listers
	${BIN}/lister-gen \
	  --logtostderr \
	  --go-header-file /dev/null \
	  --output-base    $(OUTPUT_BASE) \
	  --input-dirs     $(API_BASE)/kubernikus/v1 \
	  --output-package $(GENERATED_BASE)/listers 

$(OUTPUT)/bin/%:
	@mkdir -p _output/bin
	go build -o $@ ./vendor/k8s.io/code-generator/cmd/$*