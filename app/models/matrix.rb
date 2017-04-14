class Matrix < ActiveRecord::Base
  include Housekeeping
  include Shared::Citable              
  include Shared::Identifiable
  include Shared::IsData
  include Shared::Taggable
  include Shared::Notable
  include Shared::DataAttributes

  validates_presence_of :name

  has_many :matrix_column_items, dependent: :destroy
  has_many :matrix_row_items, dependent: :destroy

  has_many :matrix_rows
  has_many :matrix_columns

  has_many :descriptors, through: :matrix_columns 

end
