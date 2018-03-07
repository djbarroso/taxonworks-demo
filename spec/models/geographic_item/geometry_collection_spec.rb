require 'rails_helper'
require 'support/shared_contexts/shared_geo'

RSpec.describe GeographicItem::GeometryCollection, type: :model, group: [:geo, :shared_geo] do
  include_context 'stuff for complex geo tests'
  context 'that this item' do
    let(:all_items) {
      FactoryBot.build(:geographic_item_geometry_collection,
                       geometry_collection: all_shapes.as_binary)
    }
    context 'represents a geometry_collection' do
      specify 'type' do
        expect(all_items.type).to eq('GeographicItem::GeometryCollection')
      end

      specify 'valid?' do
        expect(all_items.valid?).to be_truthy
      end

      specify 'collection' do
        expect(all_items.geo_object.to_s).to eq('GEOMETRYCOLLECTION (' \
          'MULTIPOINT ((-88.241421 40.091565 0.0), (-88.241417 40.09161 0.0), (-88.241413 40.091655 0.0)), ' \
          'POINT (0.0 0.0 0.0), POINT (-29.0 -16.0 0.0), POINT (-25.0 -18.0 0.0), POINT (-28.0 -21.0 0.0), ' \
          'POINT (-19.0 -18.0 0.0), POINT (3.0 -14.0 0.0), POINT (6.0 -12.9 0.0), POINT (5.0 -16.0 0.0), ' \
          'POINT (4.0 -17.9 0.0), POINT (7.0 -17.9 0.0), POINT (32.2 22.0 0.0), POINT (-17.0 7.0 0.0), ' \
          'POINT (-9.8 5.0 0.0), POINT (-10.7 0.0 0.0), POINT (-30.0 21.0 0.0), POINT (-25.0 18.3 0.0), ' \
          'POINT (-23.0 18.0 0.0), POINT (-19.6 -13.0 0.0), POINT (-7.6 14.2 0.0), POINT (-4.6 11.9 0.0), ' \
          'POINT (-8.0 -4.0 0.0), POINT (-4.0 -8.0 0.0), POINT (-10.0 -6.0 0.0), ' \
          'LINESTRING (-32.0 21.0 0.0, -25.0 21.0 0.0, -25.0 16.0 0.0, -21.0 20.0 0.0), ' \
          'POLYGON ((-14.0 23.0 0.0, -14.0 11.0 0.0, -2.0 11.0 0.0, -2.0 23.0 0.0, -8.0 21.0 0.0, ' \
            '-14.0 23.0 0.0), (-11.0 18.0 0.0, -8.0 17.0 0.0, -6.0 20.0 0.0, -4.0 16.0 0.0, ' \
            '-7.0 13.0 0.0, -11.0 14.0 0.0, -11.0 18.0 0.0)), ' \
          'MULTILINESTRING ((23.0 21.0 0.0, 16.0 21.0 0.0, 16.0 16.0 0.0, 11.0 20.0 0.0), ' \
            '(4.0 12.6 0.0, 16.0 12.6 0.0, 16.0 7.6 0.0), (21.0 12.6 0.0, 26.0 12.6 0.0, 22.0 17.6 0.0)), ' \
          'LINESTRING (-33.0 11.0 0.0, -24.0 4.0 0.0, -26.0 13.0 0.0, -31.0 4.0 0.0, -33.0 11.0 0.0), ' \
          'GEOMETRYCOLLECTION (' \
          'POLYGON ((-19.0 9.0 0.0, -9.0 9.0 0.0, -9.0 2.0 0.0, -19.0 2.0 0.0, -19.0 9.0 0.0)), ' \
          'POLYGON ((5.0 -1.0 0.0, -14.0 -1.0 0.0, -14.0 6.0 0.0, 5.0 6.0 0.0, 5.0 -1.0 0.0)), ' \
          'POLYGON ((-11.0 -1.0 0.0, -11.0 -5.0 0.0, -7.0 -5.0 0.0, -7.0 -1.0 0.0, -11.0 -1.0 0.0)), ' \
          'POLYGON ((-3.0 -9.0 0.0, -3.0 -1.0 0.0, -7.0 -1.0 0.0, -7.0 -9.0 0.0, -3.0 -9.0 0.0)), ' \
          'POLYGON ((-7.0 -9.0 0.0, -7.0 -5.0 0.0, -11.0 -5.0 0.0, -11.0 -9.0 0.0, -7.0 -9.0 0.0))), ' \
          'MULTILINESTRING ((-20.0 -1.0 0.0, -26.0 -6.0 0.0), (-21.0 -4.0 0.0, -31.0 -4.0 0.0)), ' \
          'MULTIPOLYGON (((28.0 2.3 0.0, 23.0 -1.7 0.0, 26.0 -4.8 0.0, 28.0 2.3 0.0)), ' \
            '((22.0 -6.8 0.0, 22.0 -9.8 0.0, 16.0 -6.8 0.0, 22.0 -6.8 0.0)), ' \
            '((16.0 2.3 0.0, 14.0 -2.8 0.0, 18.0 -2.8 0.0, 16.0 2.3 0.0))), ' \
          'MULTIPOINT ((3.0 -14.0 0.0), (6.0 -12.9 0.0), (5.0 -16.0 0.0), (4.0 -17.9 0.0), (7.0 -17.9 0.0)), ' \
          'LINESTRING (27.0 -14.0 0.0, 18.0 -21.0 0.0, 20.0 -12.0 0.0, 25.0 -23.0 0.0), ' \
          'GEOMETRYCOLLECTION (' \
            'MULTIPOLYGON (((28.0 2.3 0.0, 23.0 -1.7 0.0, 26.0 -4.8 0.0, 28.0 2.3 0.0)), ' \
              '((22.0 -6.8 0.0, 22.0 -9.8 0.0, 16.0 -6.8 0.0, 22.0 -6.8 0.0)), ' \
              '((16.0 2.3 0.0, 14.0 -2.8 0.0, 18.0 -2.8 0.0, 16.0 2.3 0.0))), ' \
            'MULTIPOINT ((3.0 -14.0 0.0), (6.0 -12.9 0.0), (5.0 -16.0 0.0), (4.0 -17.9 0.0), (7.0 -17.9 0.0)), ' \
            'LINESTRING (27.0 -14.0 0.0, 18.0 -21.0 0.0, 20.0 -12.0 0.0, 25.0 -23.0 0.0)), ' \
          'POLYGON ((-33.0 -11.0 0.0, -33.0 -23.0 0.0, -21.0 -23.0 0.0, -21.0 -11.0 0.0, ' \
            '-27.0 -13.0 0.0, -33.0 -11.0 0.0)), ' \
          'LINESTRING (-16.0 -15.5 0.0, -22.0 -20.5 0.0), ' \
          'POLYGON ((-1.0 1.0 0.0, 1.0 1.0 0.0, 1.0 -1.0 0.0, -1.0 -1.0 0.0, -1.0 1.0 0.0)), ' \
          'POLYGON ((-2.0 2.0 0.0, 2.0 2.0 0.0, 2.0 -2.0 0.0, -2.0 -2.0 0.0, -2.0 2.0 0.0)), ' \
          'POLYGON ((-3.0 3.0 0.0, 3.0 3.0 0.0, 3.0 -3.0 0.0, -3.0 -3.0 0.0, -3.0 3.0 0.0)), ' \
          'POLYGON ((-4.0 4.0 0.0, 4.0 4.0 0.0, 4.0 -4.0 0.0, -4.0 -4.0 0.0, -4.0 4.0 0.0)))')
      end
    end

    context 'that a geometry_collection knows how to emits its own hash' do
      specify 'points' do
        expect(all_items.rendering_hash[:points]).to eq [[-88.241421, 40.091565],
                                                         [-88.241417, 40.09161],
                                                         [-88.241413, 40.091655],
                                                         [0.0, 0.0], [-29.0, -16.0], [-25.0, -18.0],
                                                         [-28.0, -21.0], [-19.0, -18.0], [3.0, -14.0],
                                                         [6.0, -12.9], [5.0, -16.0], [4.0, -17.9],
                                                         [7.0, -17.9], [32.2, 22.0], [-17.0, 7.0],
                                                         [-9.8, 5.0], [-10.7, 0.0], [-30.0, 21.0],
                                                         [-25.0, 18.3], [-23.0, 18.0], [-19.6, -13.0],
                                                         [-7.6, 14.2], [-4.6, 11.9], [-8.0, -4.0],
                                                         [-4.0, -8.0], [-10.0, -6.0], [3.0, -14.0],
                                                         [6.0, -12.9], [5.0, -16.0], [4.0, -17.9],
                                                         [7.0, -17.9], [3.0, -14.0], [6.0, -12.9],
                                                         [5.0, -16.0], [4.0, -17.9], [7.0, -17.9]]
      end

      specify 'lines' do
        expect(all_items.rendering_hash[:lines]).to eq([[[-32.0, 21.0], [-25.0, 21.0], [-25.0, 16.0], [-21.0, 20.0]],
                                                        [[23.0, 21.0], [16.0, 21.0], [16.0, 16.0], [11.0, 20.0]],
                                                        [[4.0, 12.6], [16.0, 12.6], [16.0, 7.6]],
                                                        [[21.0, 12.6], [26.0, 12.6], [22.0, 17.6]],
                                                        [[-33.0, 11.0], [-24.0, 4.0], [-26.0, 13.0], [-31.0, 4.0],
                                                         [-33.0, 11.0]],
                                                        [[-20.0, -1.0], [-26.0, -6.0]],
                                                        [[-21.0, -4.0], [-31.0, -4.0]],
                                                        [[27.0, -14.0], [18.0, -21.0], [20.0, -12.0], [25.0, -23.0]],
                                                        [[27.0, -14.0], [18.0, -21.0], [20.0, -12.0], [25.0, -23.0]],
                                                        [[-16.0, -15.5], [-22.0, -20.5]]])
      end

      specify 'polygons' do
        expect(all_items.rendering_hash[:polygons]).to eq([[[-14.0, 23.0], [-14.0, 11.0], [-2.0, 11.0],
                                                            [-2.0, 23.0], [-8.0, 21.0], [-14.0, 23.0]],
                                                           [[-19.0, 9.0], [-9.0, 9.0], [-9.0, 2.0],
                                                            [-19.0, 2.0], [-19.0, 9.0]],
                                                           [[5.0, -1.0], [-14.0, -1.0], [-14.0, 6.0],
                                                            [5.0, 6.0], [5.0, -1.0]],
                                                           [[-11.0, -1.0], [-11.0, -5.0], [-7.0, -5.0],
                                                            [-7.0, -1.0], [-11.0, -1.0]],
                                                           [[-3.0, -9.0], [-3.0, -1.0], [-7.0, -1.0],
                                                            [-7.0, -9.0], [-3.0, -9.0]],
                                                           [[-7.0, -9.0], [-7.0, -5.0], [-11.0, -5.0],
                                                            [-11.0, -9.0], [-7.0, -9.0]],
                                                           [[28.0, 2.3], [23.0, -1.7], [26.0, -4.8], [28.0, 2.3]],
                                                           [[22.0, -6.8], [22.0, -9.8], [16.0, -6.8], [22.0, -6.8]],
                                                           [[16.0, 2.3], [14.0, -2.8], [18.0, -2.8], [16.0, 2.3]],
                                                           [[28.0, 2.3], [23.0, -1.7], [26.0, -4.8], [28.0, 2.3]],
                                                           [[22.0, -6.8], [22.0, -9.8], [16.0, -6.8], [22.0, -6.8]],
                                                           [[16.0, 2.3], [14.0, -2.8], [18.0, -2.8], [16.0, 2.3]],
                                                           [[-33.0, -11.0], [-33.0, -23.0], [-21.0, -23.0],
                                                            [-21.0, -11.0], [-27.0, -13.0], [-33.0, -11.0]],
                                                           [[-1.0, 1.0], [1.0, 1.0], [1.0, -1.0], [-1.0, -1.0],
                                                            [-1.0, 1.0]],
                                                           [[-2.0, 2.0], [2.0, 2.0], [2.0, -2.0], [-2.0, -2.0],
                                                            [-2.0, 2.0]],
                                                           [[-3.0, 3.0], [3.0, 3.0], [3.0, -3.0], [-3.0, -3.0],
                                                            [-3.0, 3.0]],
                                                           [[-4.0, 4.0], [4.0, 4.0], [4.0, -4.0], [-4.0, -4.0],
                                                            [-4.0, 4.0]]])
      end

      specify 'all objects' do
        expect(all_items.rendering_hash).to eq({points:   [[-88.241421, 40.091565], [-88.241417, 40.09161],
                                                           [-88.241413, 40.091655], [0.0, 0.0], [-29.0, -16.0],
                                                           [-25.0, -18.0], [-28.0, -21.0], [-19.0, -18.0],
                                                           [3.0, -14.0], [6.0, -12.9], [5.0, -16.0], [4.0, -17.9],
                                                           [7.0, -17.9], [32.2, 22.0], [-17.0, 7.0], [-9.8, 5.0],
                                                           [-10.7, 0.0], [-30.0, 21.0], [-25.0, 18.3], [-23.0, 18.0],
                                                           [-19.6, -13.0], [-7.6, 14.2], [-4.6, 11.9], [-8.0, -4.0],
                                                           [-4.0, -8.0], [-10.0, -6.0], [3.0, -14.0], [6.0, -12.9],
                                                           [5.0, -16.0], [4.0, -17.9], [7.0, -17.9], [3.0, -14.0],
                                                           [6.0, -12.9], [5.0, -16.0], [4.0, -17.9], [7.0, -17.9]],
                                                lines:    [[[-32.0, 21.0], [-25.0, 21.0], [-25.0, 16.0], [-21.0, 20.0]],
                                                           [[23.0, 21.0], [16.0, 21.0], [16.0, 16.0], [11.0, 20.0]],
                                                           [[4.0, 12.6], [16.0, 12.6], [16.0, 7.6]],
                                                           [[21.0, 12.6], [26.0, 12.6], [22.0, 17.6]],
                                                           [[-33.0, 11.0], [-24.0, 4.0], [-26.0, 13.0],
                                                            [-31.0, 4.0], [-33.0, 11.0]],
                                                           [[-20.0, -1.0], [-26.0, -6.0]],
                                                           [[-21.0, -4.0], [-31.0, -4.0]],
                                                           [[27.0, -14.0], [18.0, -21.0], [20.0, -12.0], [25.0, -23.0]],
                                                           [[27.0, -14.0], [18.0, -21.0], [20.0, -12.0], [25.0, -23.0]],
                                                           [[-16.0, -15.5], [-22.0, -20.5]]],
                                                polygons: [[[-14.0, 23.0], [-14.0, 11.0], [-2.0, 11.0], [-2.0, 23.0],
                                                            [-8.0, 21.0], [-14.0, 23.0]],
                                                           [[-19.0, 9.0], [-9.0, 9.0], [-9.0, 2.0], [-19.0, 2.0],
                                                            [-19.0, 9.0]],
                                                           [[5.0, -1.0], [-14.0, -1.0], [-14.0, 6.0], [5.0, 6.0],
                                                            [5.0, -1.0]],
                                                           [[-11.0, -1.0], [-11.0, -5.0], [-7.0, -5.0], [-7.0, -1.0],
                                                            [-11.0, -1.0]],
                                                           [[-3.0, -9.0], [-3.0, -1.0], [-7.0, -1.0], [-7.0, -9.0],
                                                            [-3.0, -9.0]],
                                                           [[-7.0, -9.0], [-7.0, -5.0], [-11.0, -5.0], [-11.0, -9.0],
                                                            [-7.0, -9.0]],
                                                           [[28.0, 2.3], [23.0, -1.7], [26.0, -4.8], [28.0, 2.3]],
                                                           [[22.0, -6.8], [22.0, -9.8], [16.0, -6.8], [22.0, -6.8]],
                                                           [[16.0, 2.3], [14.0, -2.8], [18.0, -2.8], [16.0, 2.3]],
                                                           [[28.0, 2.3], [23.0, -1.7], [26.0, -4.8], [28.0, 2.3]],
                                                           [[22.0, -6.8], [22.0, -9.8], [16.0, -6.8], [22.0, -6.8]],
                                                           [[16.0, 2.3], [14.0, -2.8], [18.0, -2.8], [16.0, 2.3]],
                                                           [[-33.0, -11.0], [-33.0, -23.0], [-21.0, -23.0],
                                                            [-21.0, -11.0], [-27.0, -13.0], [-33.0, -11.0]],
                                                           [[-1.0, 1.0], [1.0, 1.0], [1.0, -1.0], [-1.0, -1.0],
                                                            [-1.0, 1.0]],
                                                           [[-2.0, 2.0], [2.0, 2.0], [2.0, -2.0], [-2.0, -2.0],
                                                            [-2.0, 2.0]],
                                                           [[-3.0, 3.0], [3.0, 3.0], [3.0, -3.0], [-3.0, -3.0],
                                                            [-3.0, 3.0]],
                                                           [[-4.0, 4.0], [4.0, 4.0], [4.0, -4.0], [-4.0, -4.0],
                                                            [-4.0, 4.0]]]})
      end
    end

    specify 'returns a lat/lng of the first point of the GeoObject' do
      expect(all_items.start_point).to eq([40.091565, -88.241421])
    end

    specify '#st_start_point returns the first POINT of the GeoObject' do
      expect(all_items.st_start_point.to_s).to eq('POINT (-88.241421 40.091565 0.0)')
    end

  end
end
