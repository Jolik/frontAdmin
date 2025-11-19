git push --tags
image="meteocontext/front-mss-admin-unigui-wine"
version=$(git describe --tags --abbrev=0)
registry="moscow.system.modext.ru:5999/"
image_with_tag=$registry$image":"$version
docker build -t $image_with_tag ./docker-wine
docker push $image_with_tag
