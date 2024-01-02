image := "genevachat/chamber"

# build latest tag and push to dockerhub with latest tag
build-latest-tag builder="default":
  #!/usr/bin/env bash
  latest_tag=$(git describe --tags $(git rev-list --tags --max-count=1))
  echo "Building $latest_tag"
  docker buildx build --builder {{builder}} --push --platform linux/arm64,linux/amd64 -t {{image}}:$latest_tag --build-arg VERSION=$latest_tag .

# build latest commit and push to dockerhub with latest tag
build-latest builder="default":
  docker buildx build --builder {{builder}} --push --platform linux/amd64 -t {{image}}:latest .

# build latest commit and push to dockerhub with commit sha tag
build-commit builder="default":
  #!/usr/bin/env bash
  set -eux

  if !(git diff-index --quiet HEAD);
  then
    echo git repo dirty
    exit 1
  fi

  commit_hash=$(git rev-parse --short HEAD)
  image_tag={{image}}:$commit_hash
  docker buildx build --builder {{builder}} --push --platform linux/arm64,linux/amd64 -t $image_tag .
  echo built: $image_tag
