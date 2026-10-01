
.PHONY: all
all:

compose = docker compose $(COMPOSE_ARGS)
compose-run = $(compose) run --rm
compose-exec = $(compose) exec -T
compose-cp = docker compose cp
wiki-exec = $(compose-exec) wiki

# ======== Build ========

.PHONY: build
build:
	$(compose) build

# ======== Develop ========

.PHONY: bash
bash:
	$(compose) exec wiki bash

# ======== Run ========

.PHONY: sqlite-up
sqlite-up:
	$(compose) up -d

.PHONY: mysql-up up
mysql-up up:
	MYSQL_HOST=mysql $(compose) --profile mysql up -d

.PHONY: wait-for-wiki
wait-for-wiki:
	$(compose-run) wait-for-wiki

.PHONY: show-status
show-status:
	$(compose) ps

.PHONY: show-logs
show-logs:
	$(compose) logs -f || exit 0

.PHONY: stop
stop:
	$(compose) stop

.PHONY: down
down:
	$(compose) down

.PHONY: destroy
destroy:
	$(compose) down --volumes --remove-orphans

# ======== ELN adapter (local test setup, see README) ========

# Sandbox accounts of the local test wiki only (same values as in docker-compose.yml). MediaWiki requires bot passwords
# of at least 32 characters from [0-9a-w].
ELN_BOT_PASSWORD ?= 0123456789abcdef0123456789abcdef
ELN_TESTER_PASSWORD ?= sandbox-eln-tester-pw-0123

.PHONY: eln-sandbox
eln-sandbox: wait-for-wiki
	$(wiki-exec) php maintenance/createAndPromote.php ElnBot $(ELN_BOT_PASSWORD) --bot || true
	$(wiki-exec) php maintenance/createAndPromote.php ElnTester $(ELN_TESTER_PASSWORD) || true
	$(wiki-exec) php maintenance/createBotPassword.php --appid adapter \
		--grants basic,highvolume,editpage,createeditmovepage ElnBot $(ELN_BOT_PASSWORD) || true

# ======== Backstop ========

backstop = $(compose-run) backstop --config backstop.config.js

.PHONY: backstop-test
backstop-test: wait-for-wiki
	$(backstop) test

.PHONY: backstop-approve
backstop-approve:
	$(backstop) approve

# ======== Backup ========

backup = $(compose) pull backup && $(compose-run) backup

.PHONY: create-backup
create-backup: wait-for-wiki
	$(backup) create

.PHONY: restore-backup
restore-backup: wait-for-wiki
	$(backup) restore

# ======== Lint ========

.PHONY: lint
lint: lint-dockerfile lint-compose

.PHONY: lint-dockerfile
lint-dockerfile:
	docker run --rm -i hadolint/hadolint < context/Dockerfile

.PHONY: lint-compose
lint-compose:
	docker compose -f docker-compose.yml config --quiet

# ======== CI ========

.PHONY: ci
ci: lint down build
	$(MAKE) with-ci destroy mysql-up disable-opcache restore-backup backstop-test
	$(MAKE) with-ci destroy
	$(eval COMPOSE_ARGS = )

.PHONY: with-ci
with-ci:
	$(eval COMPOSE_ARGS = -p docker-smw-lablsk-ci)

.PHONY: disable-opcache
disable-opcache:
	$(wiki-exec) disable-opcache.sh

