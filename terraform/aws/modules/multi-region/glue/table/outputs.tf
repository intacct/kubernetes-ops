
output "col0" {
  value = [
    for c in var.columns:
      "name = ${c[0]}"
      # "type = ${c[1]}"
  ]
}
output "col1" {
  value = [
    for c in var.columns:
      "name = ${c[1]}"
      # "type = ${c[1]}"
  ]
}
