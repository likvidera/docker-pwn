all: init
deps:
	scripts/install_deps.sh
init:
	sed -i 's/TEMPLATE_NAME/$(NAME)/g' docker-compose.yml
	sed -i 's/TEMPLATE_PORT/$(PORT)/g' docker-compose.yml
	sed -i 's/TEMPLATE_PORT/$(PORT)/g' ctf.xinetd
run:
	docker-compose -f docker-compose.yml stop
	docker-compose -f docker-compose.yml build
	docker-compose -f docker-compose.yml up -d