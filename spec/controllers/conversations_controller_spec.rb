require 'rails_helper'

RSpec.describe ConversationsController, :type => :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show'
      expect(response).to be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      get 'create'
      expect(response).to be_success
    end
  end

  describe "GET 'delete'" do
    it "returns http success" do
      get 'delete'
      expect(response).to be_success
    end
  end

  describe "GET 'mark_as_read'" do
    it "returns http success" do
      get 'mark_as_read'
      expect(response).to be_success
    end
  end

  describe "GET 'mark_as_unread'" do
    it "returns http success" do
      get 'mark_as_unread'
      expect(response).to be_success
    end
  end

end
