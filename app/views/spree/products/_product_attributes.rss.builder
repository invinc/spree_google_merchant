# docs: https://support.google.com/merchants/answer/188494?hl=en
google_merchant_product_category = Spree::Property.where(name: "google_merchant_product_category").first
google_merchant_brand            = Spree::Property.where(name: "google_merchant_brand").first
google_merchant_department       = Spree::Property.where(name: "google_merchant_department").first
google_merchant_color            = Spree::Property.where(name: "google_merchant_color").first
google_merchant_gtin             = Spree::Property.where(name: "google_merchant_gtin").first

category   = product.product_properties.where(property_id: google_merchant_product_category.id).first if google_merchant_product_category
brand      = product.product_properties.where(property_id: google_merchant_brand.id).first            if google_merchant_brand
department = product.product_properties.where(property_id: google_merchant_department.id).first       if google_merchant_department
color      = product.product_properties.where(property_id: google_merchant_color.id).first            if google_merchant_color
gtin       = product.product_properties.where(property_id: google_merchant_gtin.id).first             if google_merchant_gtin

if product.price && product.price > 0 && product.sku.present?
  xml.title product.name
  xml.description product.description
  xml.link @production_domain + '/products/' + product.slug
  xml.tag! "sku", product.sku.to_s
  xml.tag! "g:mpn", product.sku.gsub(/[^0-9a-z ]/i, '')
  # xml.tag! "brand", brand.value if brand
  xml.tag! "g:brand", "Dapper"
  xml.tag! "department", department.value if department
  xml.tag! "g:image_link", @production_domain + product.images.first.attachment.url(:product) unless product.images.empty?
  xml.tag! "g:color", color.value if color
  xml.tag! "g:gtin", gtin.value if gtin
  xml.tag! "g:price", product.price
  xml.tag! "g:google_product_category", category.value if category
  xml.tag! "g:product_type", category.value if category
  xml.tag! "g:id", product.id
  xml.tag! "g:condition", "New"
  xml.tag! "g:availability", product.master.stock_items.sum(:count_on_hand) > 0 ? 'In Stock' : 'Out of Stock'
  xml.tag! "g:shipping_weight", product.weight.to_s if product.weight.present?
end