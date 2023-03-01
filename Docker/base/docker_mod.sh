#update the docker image
sudo docker build -t neurogen22 .
sudo docker login --username=annashcherbina 
sudo docker tag f78fff21d534 annashcherbna/neurogen22:v1
sudo docker push annashcherbina/neurogen22




