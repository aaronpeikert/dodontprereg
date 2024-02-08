target "docker-metadata-action" {}

target "build" {
  inherits = ["docker-metadata-action"]
  context = "./"
  dockerfile = "Dockerfile"
  platforms = [
    "linux/amd64"
    "linux/arm64"
  ]
  args = {
    R_VERSION = "4.3.2"
    SHINY_PORT = "3838"
  }
}
