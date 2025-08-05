up:
	cd docker && docker-compose up -d
	sleep 10

stop:
	cd docker && docker-compose stop

clean:
	cd docker && docker-compose down

purge:
	cd docker && docker-compose down -v --remove-orphans
	docker network rm docker_bitcoin-regtest 2>/dev/null || true
	docker volume rm docker_bitcoin-node1-data docker_bitcoin-node2-data 2>/dev/null || true
	docker rmi docker_bitcoin-node1:latest docker_bitcoin-node2:latest 2>/dev/null || true

logs:
	cd docker && docker-compose logs -f

status:
	cd docker && docker-compose ps

test:
	curl -u bitcoin:bitcoin123 -X POST http://localhost:18443 -H "Content-Type: application/json" -d '{"jsonrpc":"1.0","id":"test","method":"getblockchaininfo","params":[]}' | jq .
	curl -u bitcoin:bitcoin123 -X POST http://localhost:18453 -H "Content-Type: application/json" -d '{"jsonrpc":"1.0","id":"test","method":"getblockchaininfo","params":[]}' | jq .

setup:
	./scripts/setup-network.sh

mine:
	./scripts/mine-blocks.sh 101

send:
	./scripts/send-transaction.sh 18443 18453 5.0

demo:
	./scripts/demo.sh