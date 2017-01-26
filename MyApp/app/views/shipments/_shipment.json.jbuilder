json.extract! shipment, :id, :weight, :height, :width, :depth, :package_type, :created_at, :updated_at
json.url shipment_url(shipment, format: :json)