all: up

up:
# 	mkdir -p /home/$$USER/data/wordpress
# 	mkdir -p /home/$$USER/data/mariadb
	docker compose -f srcs/docker-compose.yml up -d --build

ps:
	docker compose -f srcs/docker-compose.yml ps


down:
	docker compose -f srcs/docker-compose.yml down

logs:
	docker compose -f srcs/docker-compose.yml logs -f

clean: down
	docker compose -f srcs/docker-compose.yml down --volumes
# 	sudo rm -rf /home/$$USER/data/wordpress
# 	sudo rm -rf /home/$$USER/data/mariadb

re: clean up

.PHONY: all up down clean re