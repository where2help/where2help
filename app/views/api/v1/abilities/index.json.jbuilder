# frozen_string_literal: true

json.array!(@abilities) do |ability|
  json.extract! ability, :id,
                :name,
                :description
end
