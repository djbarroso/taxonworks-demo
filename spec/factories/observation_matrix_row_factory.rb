FactoryBot.define do
  factory :observation_matrix_row, traits: [:housekeeping] do
    # TODO: Make this an actual valid observation_matrix row
    factory :valid_observation_matrix_row do
      association :observation_matrix, factory: :valid_observation_matrix
      association :otu, factory: :valid_otu
      collection_object nil
    end
  end
end
