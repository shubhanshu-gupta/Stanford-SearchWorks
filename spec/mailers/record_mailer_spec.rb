require "spec_helper"

describe RecordMailer do
  describe "submit_feedback" do
    describe "with all fields" do
      let(:ip) {"123.43.54.123"}
      let(:params) { { name: "Mildred Turner ", to: "test@test.com" } }
      let(:mail) { RecordMailer.submit_feedback(params, ip) }

      it "has the correct to field" do
        expect(mail.to).to eq ["fake-email@kittenz.com"]
      end

      it "has the correct subject" do
        expect(mail.subject).to eq "Feedback from SearchWorks"
      end

      it "has the correct from field" do
        expect(mail.from).to eq ["feedback@searchworks.stanford.edu"]
      end

      it "has the correct reply to field" do
        expect(mail.reply_to).to eq ["fake-email@kittenz.com"]
      end

      it "has the right email" do
        expect(mail.body).to have_content "Name: Mildred Turner"
      end

      it "has the right name" do
        expect(mail.body).to have_content "Email: test@test.com"
      end

      it "has the right host" do
        expect(mail.body).to have_content "Host: TEST-HOST"
      end

      it "has the right IP" do
        expect(mail.body).to have_content "123.43.54.123"
      end
    end

    describe "without name and email" do
      let(:ip) {"123.43.54.123"}
      let(:params) { {  } }
      let(:mail) { RecordMailer.submit_feedback(params, ip) }

      it "has the right email" do
        expect(mail.body).to have_content "Name: No name given"
      end

      it "has the right name" do
        expect(mail.body).to have_content "Email: No email given"
      end
    end
  end
end
