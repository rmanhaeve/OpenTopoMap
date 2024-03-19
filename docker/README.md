# Docker 

Build the docker image with 
```bash
docker-compose build 
```

Start the containers
```bash
docker-compose up -d 
```

Download the data and populate the database
```bash
docker-compose run --rm mapnik bash
cd TopoMapnik && make
```