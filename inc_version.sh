git pull
new_version=$(v=$(git describe --tags --abbrev=0); base=${v%%-*}; suf=${v#$base};
  IFS='.' read -r major minor patch fourth <<< "$base";
  echo "${major}.${minor}.$((patch+1))${suf}") &&\
git tag "$new_version" && \
./push-to-docker.sh && \
echo "$new_version"
