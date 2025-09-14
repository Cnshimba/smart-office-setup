.PHONY: up down seed logs

up:
	docker compose up -d

down:
	docker compose down

seed:
	bash ./scripts/seed_db.sh

logs:
	docker compose logs -f
