require "spec_helper"

describe "catalog/record/_callnumber_browse.html.erb" do
  let(:document) {
    SolrDocument.new(
      item_display: [
        'barcode -|- library -|- home_location -|- current_location -|- type -|- truncated_callnumber -|- shelfkey -|- reverse_shelfkey -|- callnumber -|- full_shelfkey -|- -|- LC',
        'barcode2 -|- library -|- home_location -|- current_location -|- type -|- truncated_callnumber2 -|- shelfkey -|- reverse_shelfkey -|- callnumber2 -|- full_shelfkey -|- -|- DEWEY'
      ]
    )
  }
  before do
    assign(:document, document)
    render
  end
  it "should render a panel" do
    expect(rendered).to have_css('div.record-browse-nearby')
    expect(rendered).to have_css(".section#browse-nearby")
  end
  it "should render view full page link" do
    expect(rendered).to have_css('.view-full-page a')
  end
  it "should render a heading" do
    expect(rendered).to have_css('h2', text: /Browse related items/)
  end
  it "should include links to all unique callnumbers" do
    expect(rendered).to have_css('.callnumber a', text: "callnumber")
    expect(rendered).to have_css('.callnumber a', text: "callnumber2")
  end
end
