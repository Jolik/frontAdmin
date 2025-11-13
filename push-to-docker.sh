git push --tags
image="meteocontext/dcc7-front-mss"
version=$(git describe --tags --abbrev=0)
registry="moscow.system.modext.ru:5999/"
image_with_tag=$registry$image":"$version
docker build -t $image_with_tag ./docker
docker push $image_with_tag
