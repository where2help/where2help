json.array!(@abilities) do |ability|
  json.extract! ability, :id,
                         :name,
                         :description
end
