all: clean restart bench

bench:
	cd benchmarker && docker run --network host -i private-isu-benchmarker /opt/go/bin/benchmarker -t http://host.docker.internal -u /opt/go/userdata | jq && cd ../

restart:
	cd webapp  && docker compose down && docker compose up --build -d && cd ../

clean:
	rm ./webapp/log/*/*.log && rm ./webapp/public/image/*