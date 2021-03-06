require 'spec_helper'

describe BlacklightHelper do
  it "#application_name should be overridden" do
    expect(application_name).to eq "SearchWorks"
  end
  describe "#document_partial_name" do
    let(:marc) { SolrDocument.new(display_type: ["sirsi"]) }
    let(:image) { SolrDocument.new(display_type: ["image"]) }
    let(:file) { SolrDocument.new(display_type: ["file"]) }
    let(:no_display_type) { SolrDocument.new }
    let(:blacklight_config) { Blacklight::Configuration.new }
    it "should use the #display_type when available" do
      expect(document_partial_name(marc)).to eq "marc"
      expect(document_partial_name(image)).to eq "image"
      expect(document_partial_name(file)).to eq "file"
    end
    it "should fall back on the default when their is no display type" do
      expect(document_partial_name(no_display_type)).to eq "default"
    end
  end
end
