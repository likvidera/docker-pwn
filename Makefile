SH =`sed -n '3{p;q;}' docker-compose.yml | cut -f1 -d':'`
.PHONY: libc

all: init run
deps:
	scripts/install_deps.sh
init:
	sed -i 's/TEMPLATE_NAME/$(NAME)/g' docker-compose.yml
	sed -i 's/TEMPLATE_PORT/$(PORT)/g' docker-compose.yml
	sed -i 's/TEMPLATE_PORT/$(PORT)/g' ctf.xinetd
32:
	sed -i 's/#R/R/g' Dockerfile
shell:
	docker exec -it $(SH) bash
libc:
	mkdir -p libc
	docker exec $(SH) bash -c "rm -rf /tmp/libc"
	
	docker exec $(SH) bash -c "mkdir -p /tmp/libc/64"
	docker exec $(SH) bash -c "cp /lib/x86_64-linux-gnu/ld-*.so  /tmp/libc/64"
	docker exec $(SH) bash -c "cp /lib/x86_64-linux-gnu/libc-*.so  /tmp/libc/64"
	docker cp $(SH):/tmp/libc/64 libc/64/

	docker exec $(SH) bash -c "mkdir -p /tmp/libc/32"
	docker exec $(SH) bash -c "cp /lib32/ld-*.so  /tmp/libc/32"
	docker exec $(SH) bash -c "cp /lib32/libc-*.so  /tmp/libc/32"
	docker cp $(SH):/tmp/libc/32 libc/32/

	docker exec $(SH) bash -c "rm -rf /tmp/libc"
run:
	docker-compose -f docker-compose.yml stop
	docker-compose -f docker-compose.yml build
	docker-compose -f docker-compose.yml up -d