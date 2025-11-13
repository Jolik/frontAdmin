# frontAdmin
Фронт администратора для ЦСДН 7

## Compiling this uniGUI app into a Docker container

Make the proper directory structure:
```
- ./docker/etc/fmsoft/unigui/unigui_runtime           dir   # contains required uniGUI assets
- ./docker/opt/app              file  # uniGUI app binary file
- ./docker/Dockerfile           file  # Dockerfile
- ./docker/docker-run.sh        file  # Docker run script, only for manual ops
- ./docker/docker-build.sh      file  # Docker run script, only for manual ops
- ./inc_version.sh              file  # increases git tag version, builds and pushes image to docker registry
- ./push-to-docker.sh           file  # builds and pushes image to docker registry 
```

Next:
```bash
./inc_version.sh        
```
