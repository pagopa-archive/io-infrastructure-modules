output "products" {
  description = "The API Management products"
  value       = "${azurerm_api_management_product.products.*.product_id}"
}
