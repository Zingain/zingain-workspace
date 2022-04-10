NAME_development=zingain-workspace-development

COMPOSE_FILE_development=./deployments/development/docker-compose-development.yml

BASE_PATH=$(PWD)
NODE_VERSION=`node -v`
NPM_VERSION=`npm -v`

all:
	@echo
	@echo "please specifiy the command 😭"
	@echo

git:
ifeq ($(wildcard ./.git/.*),)
	@echo
	@echo "Initialize git"
	@echo
	@git init
else
	@echo "Git was already initialized"
endif

engines:
	@echo
	@echo "Configure Engines"
	@echo
	@node -e "const pkg=require('./package.json'); require('fs').writeFileSync('package.json', JSON.stringify({...pkg,engines:{node:\"${NODE_VERSION}\",npm:\"${NPM_VERSION}\"}}, null, 2));"
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,clean:\"rimraf node_modules/.cache/nx dist\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg}, null, 2));"
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,start:\"nx run-many --target=serve --all --parallel --maxParallel=20\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg}, null, 2));"
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,build:\"nx run-many --target=build --all --parallel --maxParallel=20\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg}, null, 2));"

envrc:
	@echo
	@echo "Configure envrc file"
	@echo
	@rm -rf .envrc && touch .envrc
	@echo "export PASSPHRASE_PRODUCTION='zingain-production'" >> .envrc
	@echo "export PASSPHRASE_STAGING='zingain-staging'" >> .envrc
	@echo "export PASSPHRASE_DEVELOPMENT='zingain-development'" >> .envrc
	@direnv allow

commitizen:
	@echo
	@echo "Configure commitizen"
	@echo
	@npm install --save-dev @commitlint/cli @commitlint/config-conventional commitizen commitlint-config-gitmoji cz-customizable
	@rm -rf .cz-config.js commitlint.config.js
	@curl -o .cz-config.js https://raw.githubusercontent.com/Zingain/zingain-workspace/main/.cz-config.js
	@curl -o commitlint.config.js https://raw.githubusercontent.com/Zingain/zingain-workspace/main/commitlint.config.js
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,commit:\"git-cz\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg}, null, 2));"

standard-version:
	@echo
	@echo "Configure standard version"
	@echo
	@npm install --save-dev standard-version
	@rm -rf CHANGELOG.md && touch CHANGELOG.md
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,release:\"standard-version -a\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg,\"standard-version\": { skip: { changelog: true,},scripts: {postbump: \"gitmoji-changelog update\",precommit: \"git add CHANGELOG.md\",},}}, null, 2));"

husky:
	@echo
	@echo "Configure husky"
	@echo
	@npm install --save-dev husky
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,postintall:\"husky install\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg}, null, 2));"
	@npx husky install
	@npx husky add .husky/commit-msg "npx commitlint --edit $1"

create-apps:
	@echo
	@echo "Create frontend application"
	@echo
	@npm i -D @nrwl/next
	@npx nx generate @nrwl/next:application --name=main --directory=frontend
	@echo
	@echo "Create backend application"
	@echo
	@npm i -D @nrwl/nest
	@npx nx generate @nrwl/next:application --name=main --directory=backend
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,\"frontend:serve\": \"nx run-many --target=serve --projects=frontend --parallel --maxParallel=20\",\"backend:serve\":\"nx run-many --target=serve --projects=backend --parallel --maxParallel=20\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg}, null, 2));"

hasura-init:
	@echo
	@echo "Configure Hasura"
	@echo
	@mkdir -p deployments/development && rm -rf $(COMPOSE_FILE_development) && curl -o $(COMPOSE_FILE_development) https://raw.githubusercontent.com/Zingain/zingain-workspace/main/deployments/development/docker-compose-development.yml
	@curl -o .dockerignore https://raw.githubusercontent.com/Zingain/zingain-workspace/main/.dockerignore
	@curl -o .gitignore https://raw.githubusercontent.com/Zingain/zingain-workspace/3c74e055ee8499552b362051c6814b9d312fd0e1/.gitignore
	@npm i -D @nx-tools/nx-docker
	@npx hasura init services/hasura
	@mkdir -p services/hasura && rm -rf services/hasura/.env.development && curl -o services/hasura/.env.development https://raw.githubusercontent.com/Zingain/zingain-workspace/main/services/hasura/.env.development
	@mkdir -p services/hasura/cli && rm -rf services/hasura/cli/.env.development && curl -o services/hasura/cli/.env.development https://raw.githubusercontent.com/Zingain/zingain-workspace/main/services/hasura/cli/.env.development
	@git clone https://github.com/nhost/hasura-backend-plus.git hasura-backend-plus
	@mv hasura-backend-plus/custom .
	@rm -rf ./hasura-backend-plus
	@mkdir -p services/hasura-backend-plus && rm -rf services/hasura-backend-plus/.env.development && curl -o services/hasura-backend-plus/.env.development https://raw.githubusercontent.com/Zingain/zingain-workspace/main/services/hasura-backend-plus/.env.development
	@mkdir -p services/minio && rm -rf services/minio/.env.development && curl -o services/minio/.env.development https://raw.githubusercontent.com/Zingain/zingain-workspace/main/services/minio/.env.development
	@mkdir -p services/postgres && rm -rf services/postgres/.env.development && curl -o services/postgres/.env.development https://raw.githubusercontent.com/Zingain/zingain-workspace/main/services/postgres/.env.development
	@mv custom services/hasura-backend-plus

scripts:
	@echo
	@echo "Configure necessary script files"
	@echo
	@mkdir scripts
	@rm -rf scripts/check-hasura.sh && curl -o scripts/check-hasura.sh https://raw.githubusercontent.com/Zingain/zingain-workspace/main/scripts/check-hasura.sh
	@rm -rf scripts/decrypt.sh && curl -o scripts/decrypt.sh https://raw.githubusercontent.com/Zingain/zingain-workspace/main/scripts/decrypt.sh
	@chmod +x scripts/check-hasura.sh && chmod +x scripts/decrypt.sh

codegen:
	@echo
	@echo "Configure codegen"
	@echo
	@npm i -D @graphql-codegen/cli @graphql-codegen/near-operation-file-preset @graphql-codegen/typescript @graphql-codegen/typescript-graphql-request @graphql-codegen/typescript-operations @graphql-codegen/typescript-react-apollo @graphql-codegen/typescript-urql
	@npm i urql
	@npx nx generate @nrwl/workspace:library --name=codegen-sdk
	@mkdir -p libs/codegen-sdk/src/graphql libs/codegen-sdk/src/generated apps/frontend/main/graphql
	@touch libs/codegen-sdk/src/graphql/test.graphql libs/codegen-sdk/src/generated/base-types.ts libs/codegen-sdk/src/generated/sdk.ts apps/frontend/main/graphql/test.graphql
	@echo "export * from './generated/sdk';" > libs/codegen-sdk/src/index.ts
	@rm -rf libs/codegen-sdk/src/lib
	@curl -o codegen.config.yml https://raw.githubusercontent.com/Zingain/zingain-workspace/main/codegen.config.yml
	@node -e "const pkg=require('./package.json'); pkg[\"scripts\"]={...pkg.scripts,codegen: \"graphql-codegen --config codegen.config.yml -w\"}; require('fs').writeFileSync('package.json', JSON.stringify({...pkg}, null, 2));"

tailwind:
	@echo
	@echo "Configure tailwind in NEXT"
	@echo
	@npm i -D autoprefixer postcss tailwindcss
	@mkdir apps/frontend/main/styles && touch apps/frontend/main/styles/global.css
	@echo "@tailwind base;" >> apps/frontend/main/styles/global.css
	@echo "@tailwind components;" >> apps/frontend/main/styles/global.css
	@echo "@tailwind utilities;" >> apps/frontend/main/styles/global.css
	@curl -o apps/frontend/main/tailwind.config.js   https://raw.githubusercontent.com/Zingain/zingain-workspace/main/apps/frontend/main/tailwind.config.js
	@curl -o apps/frontend/main/postcss.config.js   https://raw.githubusercontent.com/Zingain/zingain-workspace/main/apps/frontend/main/postcss.config.js

initial-workspace:
	@$(MAKE) --no-print-directory git
	@$(MAKE) --no-print-directory engines
	@$(MAKE) --no-print-directory envrc
	@$(MAKE) --no-print-directory commitizen
	@$(MAKE) --no-print-directory standard-version
	@$(MAKE) --no-print-directory husky
	@$(MAKE) --no-print-directory create-apps
	@$(MAKE) --no-print-directory hasura-init
	@$(MAKE) --no-print-directory scripts
	@$(MAKE) --no-print-directory codegen
	@$(MAKE) --no-print-directory tailwind
	@echo
	@echo "In the codegen config file update the baseTypesPath from '~@zingain-workspace/codegen-sdk/base-types' to '~@{your-workspace-name}/codegen-sdk/base-types'"
	@echo
	@echo "Please import the global/styles.css file in your frontend for accessing trailwind commands."

encrypt-envs:
	@echo
	@echo "🗝️ Encrypt secrets in development"
	@echo
	@find . -name ".env.development.gpg" -exec rm -rf {} ';'
	@find . -name ".env.development" -exec gpg --passphrase "$(PASSPHRASE_DEVELOPMENT)" --quiet --yes --batch -c {} ';'
	@echo
	@echo "🗝️ Encrypt secrets in staging"
	@echo
	@find . -name ".env.staging.gpg" -exec rm -rf {} ';'
	@find . -name ".env.staging" -exec gpg --passphrase "$(PASSPHRASE_STAGING)" --quiet --yes --batch -c {} ';'
	@echo
	@echo "🗝️ Encrypt secrets in production"
	@echo
	@find . -name ".env.production.gpg" -exec rm -rf {} ';'
	@find . -name ".env.production" -exec gpg --passphrase "$(PASSPHRASE_PRODUCTION)" --quiet --yes --batch -c {} ';'

decrypt-envs:
	@echo
	@echo "🔓 Decrypt secrets development"
	@echo
	@chmod +x ./scripts/decrypt.sh
	@./scripts/decrypt.sh "$(PWD)" "$(PASSPHRASE_DEVELOPMENT)" "development"
	@echo
	@echo "🔓 Decrypt secrets staging"
	@echo
	@./scripts/decrypt.sh "$(PWD)" "$(PASSPHRASE_STAGING)" "staging"
	@echo
	@echo "🔓 Decrypt secrets production"
	@echo
	@./scripts/decrypt.sh "$(PWD)" "$(PASSPHRASE_PRODUCTION)" "production"

build:
	@echo
	@echo "🏭 Building $(stage) service containers"
	@echo
	@COMPOSE_DOCKER_CLI_BUILD=1 BASE_PATH=$(BASE_PATH) docker-compose -f $(COMPOSE_FILE_$(stage)) -p $(NAME_$(stage)) build

push:
	@echo
	@echo "⤴️ Uploading $(stage) service containers"
	@echo
	@COMPOSE_DOCKER_CLI_BUILD=1 BASE_PATH=$(BASE_PATH) docker-compose -f $(COMPOSE_FILE_$(stage)) -p $(NAME_$(stage)) push

pull:
	@echo
	@echo "⤵️ Downloading $(stage) containers"
	@echo
	@COMPOSE_DOCKER_CLI_BUILD=1 BASE_PATH=$(BASE_PATH) docker-compose -f $(COMPOSE_FILE_$(stage)) -p $(NAME_$(stage)) pull

deploy:
	@echo
	@echo "💻 Deploying $(stage) services"
	@echo
	@COMPOSE_DOCKER_CLI_BUILD=1 BASE_PATH=$(BASE_PATH) docker-compose -f $(COMPOSE_FILE_$(stage)) -p $(NAME_$(stage)) up -d

delete:
	@echo
	@echo "🗑️ Deleting $(stage) services"
	@echo
ifneq (,$(findstring i, $(MAKEFLAGS)))
	@COMPOSE_DOCKER_CLI_BUILD=1 BASE_PATH=$(BASE_PATH) docker-compose -f $(COMPOSE_FILE_$(stage)) -p $(NAME_$(stage)) down -v
else
	@COMPOSE_DOCKER_CLI_BUILD=1 BASE_PATH=$(BASE_PATH) docker-compose -f $(COMPOSE_FILE_$(stage)) -p $(NAME_$(stage)) down
endif

build-deploy:
	@echo
	@echo "🏭 ➡️ 💻 Building & Deploying $(stage) services"
	@echo
	@COMPOSE_DOCKER_CLI_BUILD=1 BASE_PATH=$(BASE_PATH) docker-compose -f $(COMPOSE_FILE_$(stage)) -p $(NAME_$(stage)) up -d --build


clean-cache:
	@echo
	@echo "🗑️ Cleaning Caches"
	@echo
	@docker system prune --volumes -f

clean:
	@echo
	@echo "🗑️ Deleting and removing all deployments"
	@echo
	@docker system prune -a -f

hasura-migrate:
	@echo
	@echo "🚲 Migrating $(stage) hasura"
	@echo
	@npx hasura --project $(BASE_PATH)/services/hasura --envfile cli/.env.$(stage) migrate apply --database-name 'default'
	@npx hasura --project $(BASE_PATH)/services/hasura --envfile cli/.env.$(stage) metadata apply

hasura-console:
	@echo
	@echo "⚙️ Loading $(stage) hasura console"
	@echo
	@npx hasura --project $(BASE_PATH)/services/hasura --envfile cli/.env.$(stage) console

hasura-seed:
	@echo
	@echo "🪴 Seeding $(stage) hasura"
	@echo
	@npx hasura --project $(BASE_PATH)/services/hasura --envfile cli/.env.$(stage) seeds apply --database-name 'default'


check-hasura:
	@./scripts/check-hasura.sh "$(BASE_PATH)" "$(stage)"

recreate:
	@$(MAKE) --no-print-directory delete -i
	@$(MAKE) --no-print-directory decrypt-envs
	@$(MAKE) --no-print-directory build-deploy
	@$(MAKE) --no-print-directory check-hasura
	@$(MAKE) --no-print-directory hasura-migrate
	@$(MAKE) --no-print-directory hasura-seed

create-seed:
	npx hasura --project $(BASE_PATH)/services/hasura --envfile cli/.env.$(stage)  --database-name 'default' seed create $(name) \
	--from-table auth.accounts \
	--from-table auth.account_roles \
	--from-table auth.account_providers \
  --from-table auth.refresh_tokens \
	--from-table users
