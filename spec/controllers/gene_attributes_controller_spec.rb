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

RSpec.describe GeneAttributesController, type: :controller do
  before(:each){
    sign_in
  }
  
  # This should return the minimal set of attributes required to create a valid
  # GeneAttribute. As you add validations to GeneAttribute, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    strip_housekeeping_attributes(FactoryBot.build(:valid_gene_attribute).attributes)
  }

  let(:invalid_attributes) {
    {descriptor_id: nil, sequence_id: nil}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # GeneAttributesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'assigns all gene_attributes as @gene_attributes' do
      gene_attribute = GeneAttribute.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:recent_objects)).to eq([gene_attribute])
    end
  end

  describe 'GET #show' do
    it 'assigns the requested gene_attribute as @gene_attribute' do
      gene_attribute = GeneAttribute.create! valid_attributes
      get :show, params: {id: gene_attribute.to_param}, session: valid_session
      expect(assigns(:gene_attribute)).to eq(gene_attribute)
    end
  end

  describe 'GET #new' do
    it 'assigns a new gene_attribute as @gene_attribute' do
      get :new, params: {}, session: valid_session
      expect(assigns(:gene_attribute)).to be_a_new(GeneAttribute)
    end
  end

  describe 'GET #edit' do
    it 'assigns the requested gene_attribute as @gene_attribute' do
      gene_attribute = GeneAttribute.create! valid_attributes
      get :edit, params: {id: gene_attribute.to_param}, session: valid_session
      expect(assigns(:gene_attribute)).to eq(gene_attribute)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new GeneAttribute' do
        expect {
          post :create, params: {gene_attribute: valid_attributes}, session: valid_session
        }.to change(GeneAttribute, :count).by(1)
      end

      it 'assigns a newly created gene_attribute as @gene_attribute' do
        post :create, params: {gene_attribute: valid_attributes}, session: valid_session
        expect(assigns(:gene_attribute)).to be_a(GeneAttribute)
        expect(assigns(:gene_attribute)).to be_persisted
      end

      it 'redirects to the created gene_attribute' do
        post :create, params: {gene_attribute: valid_attributes}, session: valid_session
        expect(response).to redirect_to(GeneAttribute.last)
      end
    end

    context 'with invalid params' do
      it 'assigns a newly created but unsaved gene_attribute as @gene_attribute' do
        post :create, params: {gene_attribute: invalid_attributes}, session: valid_session
        expect(assigns(:gene_attribute)).to be_a_new(GeneAttribute)
      end

      it "re-renders the 'new' template" do
        post :create, params: {gene_attribute: invalid_attributes}, session: valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { sequence_relationship_type: 'SequenceRelationship::ReversePrimer' }
      }

      it 'updates the requested gene_attribute' do
        gene_attribute = GeneAttribute.create! valid_attributes
        put :update, params: {id: gene_attribute.to_param, gene_attribute: new_attributes}, session: valid_session
        gene_attribute.reload
        expect(gene_attribute.sequence_relationship_type).to eq('SequenceRelationship::ReversePrimer')
      end

      it 'assigns the requested gene_attribute as @gene_attribute' do
        gene_attribute = GeneAttribute.create! valid_attributes
        put :update, params: {id: gene_attribute.to_param, gene_attribute: valid_attributes}, session: valid_session
        expect(assigns(:gene_attribute)).to eq(gene_attribute)
      end

      it 'redirects to the gene_attribute' do
        gene_attribute = GeneAttribute.create! valid_attributes
        put :update, params: {id: gene_attribute.to_param, gene_attribute: valid_attributes}, session: valid_session
        expect(response).to redirect_to(gene_attribute)
      end
    end

    context 'with invalid params' do
      it 'assigns the gene_attribute as @gene_attribute' do
        gene_attribute = GeneAttribute.create! valid_attributes
        put :update, params: {id: gene_attribute.to_param, gene_attribute: invalid_attributes}, session: valid_session
        expect(assigns(:gene_attribute)).to eq(gene_attribute)
      end

      it "re-renders the 'edit' template" do
        gene_attribute = GeneAttribute.create! valid_attributes
        put :update, params: {id: gene_attribute.to_param, gene_attribute: invalid_attributes}, session: valid_session
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested gene_attribute' do
      gene_attribute = GeneAttribute.create! valid_attributes
      expect {
        delete :destroy, params: {id: gene_attribute.to_param}, session: valid_session
      }.to change(GeneAttribute, :count).by(-1)
    end

    it 'redirects to the gene_attributes list' do
      gene_attribute = GeneAttribute.create! valid_attributes
      delete :destroy, params: {id: gene_attribute.to_param}, session: valid_session
      expect(response).to redirect_to(gene_attributes_url)
    end
  end

end
