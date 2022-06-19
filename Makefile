all: bench restart

bench:
	cd benchmarker && docker run --network host -i private-isu-benchmarker /opt/go/bin/benchmarker -t http://host.docker.internal -u /opt/go/userdata | jq && cd ../

restart:
	cd webapp && rm ./public/image/* && docker compose down && docker compose up --build -d && cd ../
