require 'spec_helper'

describe AccessPanelHelper do
  let(:library) { Holdings::Library.new("GREEN") }
  describe "link_to_library" do
    it "should return a link to library about page" do
      expect(helper.link_to_library(library)).to eq "<a href=\"http://library.stanford.edu/libraries/green/about\">Green Library</a>"
    end
  end

  describe "thumb_for_library" do
    it "should return the image tag for the thumbnail for the specified library" do
      expect(helper.thumb_for_library(library)).to eq "<img alt=\"\" class=\"pull-left\" src=\"/assets/GREEN.jpg\" />"
    end
  end
end
