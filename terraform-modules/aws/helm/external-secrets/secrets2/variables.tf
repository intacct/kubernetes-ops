variable "external_secret" {
  type = map(object({
    name              = string
    namespace         = string
    allowed_namespaces = string
    data = list(object({
      secret_key     = string
      remote_key     = string
      remote_property = string
    }))
  }))
}
