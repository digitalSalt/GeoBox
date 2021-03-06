require "rails_helper"

RSpec.describe DocumentsHelper, :type => :helper do
  describe "#mutualRadius?" do
    it "returns true when user is within doc. radius" do
      userCurrentLatlng = {lat: 100, lng: 100}
      expect(DocumentsHelper.mutualRadius?(userCurrentLatlng, 100, 100)).to be true
    end

    it "returns false when user is out of doc. radius" do
      userCurrentLatlng = {lat: 1000, lng: 1000}
      expect(DocumentsHelper.mutualRadius?(userCurrentLatlng, 100, 100)).to be false
    end

    it "returns only documents within the radius" do
      document1 = FactoryBot.create(:document)
      document2 = FactoryBot.create(:document)
      userCurrentLatlng = {lat: 100, lng: 100}
      expect(DocumentsHelper.fetchfiles(userCurrentLatlng)).not_to be_empty
      puts "======================================="
      puts document1.filename
      puts document2.filename
      puts DocumentsHelper.fetchfiles(userCurrentLatlng).first[:filename]
      puts DocumentsHelper.fetchfiles(userCurrentLatlng).second[:filename]
      puts "======================================="
      expect(DocumentsHelper.fetchfiles(userCurrentLatlng).first[:filename]).to eq("document6")
      expect(DocumentsHelper.fetchfiles(userCurrentLatlng).second[:filename]).to eq("document7")
    end

    it "returns empty array when user is out of document's radius" do
      document = FactoryBot.create(:document, latitude: 1000, longitude: 1000)
      userCurrentLatlng = {lat: 100, lng: 100}
      expect(DocumentsHelper.fetchfiles(userCurrentLatlng)).to eq([])
    end

  end
end
