restart:
	cd webapp  && docker compose down && docker compose up --build -d && cd ../

clean:
	rm ./webapp/log/*/*.log && rm ./webapp/public/image/*

bench: clean restart
	sleep 5
	cd benchmarker && docker run --network host -i private-isu-benchmarker /opt/go/bin/benchmarker -t http://host.docker.internal -u /opt/go/userdata | jq && cd ../

alp:
	alp json \
    --sort sum -r \
    -m "/posts/\d+,/image/\d+,/@\w+" \
    -o count,method,uri,min,avg,max,sum \
    --file ./webapp/log/nginx/access.log | tee nginx_digest_$(shell date +%Y%m%d%H%M).log

pqd:
	pt-query-digest --type slowlog ./webapp/log/mysql/mysql-slow.log | tee sql_digest_$(shell date +%Y%m%d%H%M).log

analyze: alp pqd
