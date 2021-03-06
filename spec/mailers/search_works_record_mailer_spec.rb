require "spec_helper"

describe SearchWorksRecordMailer do
  include MarcMetadataFixtures
  include ModsFixtures
  let(:documents) {
    [
      SolrDocument.new(
        id: '123',
        title_display: "Title1",
        item_display: ["12345 -|- GREEN -|- STACKS -|- -|- -|- -|- -|- -|- ABC 123"],
        url_sfx: ["http://library.stanford.edu"],
        modsxml: mods_everything
      ),
      SolrDocument.new(
        id: '321',
        title_display: "Title2",
        item_display: ["54321 -|- SAL3 -|- STACKS -|- -|- -|- -|- -|- -|- ABC 321"],
        url_sfx: ["http://stacks.stanford.edu"],
        marcxml: metadata1
      )
    ]
  }
  let(:params) { {to: 'email@example.com', message: 'The message', subject: 'The subject'} }
  let(:url_params) { {host: 'example.com'} }
  describe 'email_record' do
    let(:mail) { SearchWorksRecordMailer.email_record(documents, params, url_params) }
    it 'should send a plain-text email' do
      expect(mail.content_type).to match /text\/plain/
    end
    it 'should include the provided message' do
      expect(mail.body).to include "Message: The message"
    end
    it 'should include the titles of all documents' do
      expect(mail.body).to include "Title: Title1"
      expect(mail.body).to include "Title: Title2"
    end
    it 'should include the callnumbers' do
      expect(mail.body).to include "Green Library - Stacks"
      expect(mail.body).to include "ABC 123"

      expect(mail.body).to include "SAL3 (off-campus storage) - Stacks"
      expect(mail.body).to include "ABC 321"
    end
    it 'should include the URLs' do
      expect(mail.body).to include "Online:"
      expect(mail.body).to include "http://library.stanford.edu"
      expect(mail.body).to include "http://stacks.stanford.edu"
    end
    it 'should include the URL to all the documents' do
      expect(mail.body).to include "Bookmark: http://example.com/view/123"
      expect(mail.body).to include "Bookmark: http://example.com/view/321"
    end
  end
  describe 'full_email_record' do
    let(:mail) { SearchWorksRecordMailer.full_email_record(documents, params, url_params) }
    it 'should send a html email' do
      expect(mail.content_type).to match /text\/html/
    end
    it 'should include full HTML markup' do
      expect(mail.body).to have_css('html')
      expect(mail.body).to have_css('body')
    end
    it 'should include the titles of all documents as links' do
      expect(mail.body).to have_css('h1 a', text: 'Title1')
      expect(mail.body).to have_css('h1 a', text: 'Title2')
    end
    it 'should include Subjects and Bibliographic information from both MARC and MODS records' do
      expect(mail.body).to have_css('h2', text: 'Subjects', count: 2)
      expect(mail.body).to have_css('h2', text: 'Bibliographic information', count: 2)
    end
    it 'should include the HTML markup for MARC records' do
      expect(mail.body).to have_css('dt', text: 'Related Work')
      expect(mail.body).to have_css('dd', text: 'A quartely publication.')
    end
    it 'should include the HTML markup for MODS records' do
      expect(mail.body).to have_css('dt', text: 'Contributor')
      expect(mail.body).to have_css('dd', text: 'B. Smith (Producer)')
    end
    it 'should include holdings of all documents' do
      expect(mail.body).to have_css('h2', text: 'At the library', count: documents.length)
      expect(mail.body).to have_css('dt', text: 'Green Library - Stacks')
      expect(mail.body).to have_css('dd', text: 'ABC 123')

      expect(mail.body).to have_css('dt', text: 'SAL3 (off-campus storage) - Stacks')
      expect(mail.body).to have_css('dd', text: 'ABC 321')
    end
    it 'should include links of all the documents' do
      expect(mail.body).to have_css('h2', text: 'Online')
      expect(mail.body).to have_css('a', text: 'Find full text', count: documents.length)
    end
    it 'should separate records w/ a horizontal rule' do
      expect(mail.body).to have_css('hr', count: documents.length)
    end
  end
end
