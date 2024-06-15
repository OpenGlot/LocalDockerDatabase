docker rm my_postgres_container
docker build -t my_postgres_image .
docker run --name my_postgres_container -d -p 6543:5432 my_postgres_image
