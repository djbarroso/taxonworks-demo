# A RangedLot is a CollectionObject that is not enumerated in a range (i.e. not a simple integer).
#
class RangedLot < CollectionObject::BiologicalCollectionObject 
  belongs_to :ranged_lot_category, inverse_of: :ranged_lots
  validates_presence_of :ranged_lot_category_id
end



