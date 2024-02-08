target "docker-metadata-action" {}

target "base" {
  inherits = ["docker-metadata-action"]
  context = "./"
  dockerfile = "Dockerfile"
  target = "shinylive" # specify the target stage in Dockerfile
  platforms = [
    "linux/amd64"
    ]
  args = {
    R_VERSION = "4.3.2",
  }
}
