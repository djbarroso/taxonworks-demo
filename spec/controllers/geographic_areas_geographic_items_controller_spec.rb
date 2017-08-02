require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe GeographicAreasGeographicItemsController, :type => :controller do
  before(:each) {
    sign_in
  }

  before(:all) {
    # FactoryGirl.create(:earth_geographic_area)
  }

  after(:all) {
    GeographicAreasGeographicItem.delete_all
  }

  # This should return the minimal set of attributes required to create a valid
  # GeographicAreasGeographicItem. As you add validations to GeographicAreasGeographicItem, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    strip_housekeeping_attributes(FactoryGirl.build(:valid_geographic_areas_geographic_item).attributes)
}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GeographicAreasGeographicItemsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET new" do
    it "assigns a new geographic_areas_geographic_item as @geographic_areas_geographic_item" do
      get :new, params: {}, session: valid_session
      expect(assigns(:geographic_areas_geographic_item)).to be_a_new(GeographicAreasGeographicItem)
    end
  end

  describe "GET edit" do
    it "assigns the requested geographic_areas_geographic_item as @geographic_areas_geographic_item" do
      geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
      get :edit, params: {id: geographic_areas_geographic_item.to_param}, session: valid_session
      expect(assigns(:geographic_areas_geographic_item)).to eq(geographic_areas_geographic_item)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new GeographicAreasGeographicItem" do
        expect {
          post :create, params: {geographic_areas_geographic_item: valid_attributes}, session: valid_session
        }.to change(GeographicAreasGeographicItem, :count).by(1)
      end

      it "assigns a newly created geographic_areas_geographic_item as @geographic_areas_geographic_item" do
        post :create, params: {geographic_areas_geographic_item: valid_attributes}, session: valid_session
        expect(assigns(:geographic_areas_geographic_item)).to be_a(GeographicAreasGeographicItem)
        expect(assigns(:geographic_areas_geographic_item)).to be_persisted
      end

      it "redirects to the created geographic_areas_geographic_item" do
        post :create, params: {geographic_areas_geographic_item: valid_attributes}, session: valid_session
        expect(response).to redirect_to(GeographicAreasGeographicItem.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved geographic_areas_geographic_item as @geographic_areas_geographic_item" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(GeographicAreasGeographicItem).to receive(:save).and_return(false)
        post :create, params: {geographic_areas_geographic_item: {geographic_area_id: "invalid value"}}, session: valid_session
        expect(assigns(:geographic_areas_geographic_item)).to be_a_new(GeographicAreasGeographicItem)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(GeographicAreasGeographicItem).to receive(:save).and_return(false)
        post :create, params: {geographic_areas_geographic_item: {geographic_area_id: "invalid value"}}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      it 'updates the requested geographic_areas_geographic_item' do
        geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
        # Assuming there are no other geographic_areas_geographic_items in the database, this
        # specifies that the GeographicAreasGeographicItem created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        update_params = ActionController::Parameters.new({geographic_area_id: '1'}).permit(:geographic_area_id)
        expect_any_instance_of(GeographicAreasGeographicItem).to receive(:update).with(update_params)
        put :update, params: {id: geographic_areas_geographic_item.to_param, geographic_areas_geographic_item: {geographic_area_id: '1'}}, session: valid_session
      end

      it 'assigns the requested geographic_areas_geographic_item as @geographic_areas_geographic_item' do
        geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
        put :update, params: {id: geographic_areas_geographic_item.to_param, geographic_areas_geographic_item: valid_attributes}, session: valid_session
        expect(assigns(:geographic_areas_geographic_item)).to eq(geographic_areas_geographic_item)
      end

      it 'redirects to the geographic_areas_geographic_item' do
        geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
        put :update, params: {id: geographic_areas_geographic_item.to_param, geographic_areas_geographic_item: valid_attributes}, session: valid_session
        expect(response).to redirect_to(geographic_areas_geographic_item)
      end
    end

    describe "with invalid params" do
      it "assigns the geographic_areas_geographic_item as @geographic_areas_geographic_item" do
        geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(GeographicAreasGeographicItem).to receive(:save).and_return(false)
        put :update, params: {id: geographic_areas_geographic_item.to_param, geographic_areas_geographic_item: {geographic_area_id: "invalid value"}}, session: valid_session
        expect(assigns(:geographic_areas_geographic_item)).to eq(geographic_areas_geographic_item)
      end

      it "re-renders the 'edit' template" do
        geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(GeographicAreasGeographicItem).to receive(:save).and_return(false)
        put :update, params: {id: geographic_areas_geographic_item.to_param, geographic_areas_geographic_item: {geographic_area_id: "invalid value"}}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested geographic_areas_geographic_item" do
      geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
      expect {
        delete :destroy, params: {id: geographic_areas_geographic_item.to_param}, session: valid_session
      }.to change(GeographicAreasGeographicItem, :count).by(-1)
    end

    it "redirects to the geographic_areas_geographic_items list" do
      geographic_areas_geographic_item = GeographicAreasGeographicItem.create! valid_attributes
      delete :destroy, params: {id: geographic_areas_geographic_item.to_param}, session: valid_session
      expect(response).to redirect_to(geographic_areas_geographic_items_url)
    end
  end

end
