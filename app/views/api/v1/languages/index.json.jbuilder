json.array!(@languages) do |language|
  json.extract! language, :id,
    :name
end
