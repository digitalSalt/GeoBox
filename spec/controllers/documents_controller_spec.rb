require "rails_helper"

RSpec.describe DocumentsController, type: :controller do
  describe "#index" do
    let(:user) { FactoryBot.create(:user) }
    context "as an admin user" do
      it "responds successfully" do
        login_as_admin
        get :index
        expect(response).to be_success
      end
    end

    # it should respond successfully to index page for the owner
    context "as not an admin user" do
      it "responds unsucessfully for regular user" do
        login(user)
        get :index
        expect(response).to_not be_success
      end

      it "responds unsucessfully for guest" do
        get :index
        expect(response).to_not be_success
      end

      it "redirects to the login page" do
        get :index
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#show" do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @document = FactoryBot.create(:document, user_id: @user1.id)
    end
    context "as an authorized (owner) user" do
      it "responds successfully" do
        login(@user1)
        get :show, id: @document.id
        expect(response).to be_success
      end
    end

    context "as an unauthorized user" do
      it "responds sucessfully for all users not the owner" do
        login(@user2)
        get :show, id: @document.id
        expect(response).to be_success
        # This is because documents is viewable to all users
        # expect(response).not_to be_success
        # expect(response).to redirect_to root_path
        # will decide where it should redirect to
      end

      it "redirects to the login page for guest" do
        get :show, id: @document.id
        expect(response).to redirect_to login_path
      end
    end
  end

  describe "#update" do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @document = FactoryBot.create(:document, user_id: @user1.id)
    end

    context "as an authorized user" do
      it "updates a document" do
        # test is ommitted is no ui exists in spec for document description update
        # login(@user1)
        # patch :update, id: @document.id, params: {description: "old_description", attachment:"some url", book_id: 1}
        # expect(@document.reload.description).to eq "new description"
        # expect(response).to redirect_to documents_path # to be constrained only show list of the owner's documents
        # expect(flash[:success]).to include "Document was successfully updated."
      end
    end

    context "as an authorized user" do
      it "does not update a document" do
        # test is ommitted is no ui exists in spec for document description update
        # doc_params = FactoryBot.attributes_for(:document, description: "old_description")
        # login(@user2)
        # patch :update, id: @document.id, description: "new_description"
        # expect(@document.reload.description).to eq "old_description"
        # expect(flash[:danger]).not_to be_nil
      end
    end
  end

end
