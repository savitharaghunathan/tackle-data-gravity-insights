.PHONY: all help venv install lint test neo4j

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-\\.]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

all: help

venv: ## Create a Python virtual environment
	$(info Creating Python 3 virtual environment...)
	python3 -m venv .venv
	$(info To use: source .venv/bin/activate)

install: ## Install development version of DGI
	$(info Installing development version of DGI...)
	sudo pip install -e '.[dev]'

lint: ## Run the linter
	$(info Running linting...)
	flake8 dgi --count --select=E9,F63,F7,F82 --show-source --statistics
	flake8 dgi --count --max-complexity=10 --max-line-length=127 --statistics

test: ## Run the unit tests
	$(info Running tests...)
	nosetests --with-spec --spec-color

neo4j: ## Start Neo4J in Docker
	$(info Starting Neo4J server...)
	export NEO4J_BOLT_URL="bolt://neo4j:tackle@localhost:7687"
	docker run -d --name neo4j -p 7474:7474 -p 7687:7687 -e NEO4J_AUTH="neo4j/tackle" neo4j
