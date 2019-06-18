# android-docker 

This docker is to build Android Gradle project from Jenkins 2.0 (uses docker plugin)
It's available on Docker Hub https://hub.docker.com/r/vision360degres/android/

## Contribute

Each docker image is composed of 1 android version, 1 api level and 1 build tools supported. This limitation is to limit the image size. There is actually no support for emulator.

### Update tools

To update for a new version, in the Dockerfile, change the 3 environement variables:
 * ANDROID_VERSION: Version of SDK android to download
 * ANDROID_API_LEVEL: The platform API level to target
 * ANDROID_BUILD_TOOLS_VERSION: the build tools to use (can be upgraded during build automatically)

### Test 

Then, you can build a new image to test it

```
docker build -t vision360degres/androidtest .
```

If building fail you can debug via where 1b372b1f76f2 is partial build

```
docker run --tty --interactive --rm 1b372b1f76f2 /bin/bash
```

After build successful, you can test image to build your project, go into your workspace android project and run this command

```
docker run --tty --interactive --volume=$(pwd):/opt/workspace --workdir=/opt/workspace --rm vision360degres/androidtest  /bin/sh -c "./gradlew build"
```

If the build successful, the image can be pushed.

### Push a new version

Dockerhub is plug on github. When you push a new commit/tag, the build is started from docker hub and if success, new image is available.

Each new commit on master will build a new latest version from docker hub.
Each new tag will build a new tag (with the same name) from docker hub.

There is only one branch with the latest version. Tag must be create for each new version.
