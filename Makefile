restart:
	cd webapp  && docker compose down && docker compose up --build -d && cd ../

clean:
	rm -f ./webapp/log/*/*.log && rm -f ./webapp/public/image/*

bench: clean restart
	sleep 5
	cd benchmarker && docker run --network host -i private-isu-benchmarker /opt/go/bin/benchmarker -t http://host.docker.internal -u /opt/go/userdata > ../result_$(shell date +%Y%m%d%H%M).log && cd ../

alp:
	alp json \
    --sort sum -r \
    -m "/posts/\d+,/image/\d+,/@\w+" \
    -o count,method,uri,min,avg,max,sum \
    --file ./webapp/log/nginx/access.log > nginx_digest_$(shell date +%Y%m%d%H%M).log

pqd:
	pt-query-digest --type slowlog ./webapp/log/mysql/mysql-slow.log > sql_digest_$(shell date +%Y%m%d%H%M).log

analyze: alp pqd
