status:
	docker compose ls
	docker container ls
	docker volume ls
	docker network ls

watch:
	watch -n 5 make status 

shutdown:
	docker compose down

shutdown_volumes:
	docker compose down -v

start: shutdown
	docker compose --profile db up

exec:
	docker exec -it demo-postgres /bin/bash
	
backup:
	docker exec -t postgres pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

connect_via_psql:
	docker exec -it postgres psql -U postgres