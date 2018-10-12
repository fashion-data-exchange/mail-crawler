require "spec_helper"

RSpec.describe FDE::MailCrawler do
  let(:test_mail) {
    Mail.read('./spec/fixtures/test_mail.eml')
  }

  it "has a version number" do
    expect(FDE::MailCrawler::VERSION).not_to be nil
  end

  context 'configuration' do
    let(:attributes) do
      {
        address: 'imap.example.com',
        port: '143',
        domain: 'example.com',
        user_name: 'example@example.com',
        password: 'secret',
        enable_ssl: 'true',
        authentication: 'plain',
        enable_starttls_auto: 'false'
      }
    end

    it 'yields the config block' do
      expect do |b|
        subject.configure(&b)
      end.to yield_with_args
    end

    it 'should have the configs as attributes' do
      expect(subject.config.attributes).to eq(attributes)
    end
  end

  context 'mail' do
    it 'should be of type Mail' do
      expect(subject.imap_account).to be_a(Mail::IMAP)
    end
  end

  context 'crawl' do
    it 'should return an array' do
      allow(subject).to receive(:crawl) { [test_mail] }
      expect(subject.crawl).to be_a(Array)
    end

    it 'should have at least one mail' do
      allow(subject).to receive(:crawl) { [test_mail] }
      expect(subject.crawl.length).to be > 0
    end

    it 'should return array of mails' do
      allow(subject).to receive(:crawl) { [test_mail] }
      expect(subject.crawl.first).to be_a(Mail::Message)
    end
  end

  context 'watch' do
    def dummy_method(mail)
      "I am the mail #{mail.subject}"
    end

    it 'calls the dummy_method' do
      allow(subject).to receive(:watch) { [test_mail] }
      subject.watch do |mail|
        expect(dummy_method(mail)).to eq("I am the mail #{mail.subject}")
      end
    end

    it 'should returns mails' do
      allow(subject).to receive(:watch) { [test_mail] }
      subject.watch do |mail|
        expect(mail).to be_a(Mail::Message)
      end
    end
  end

  context 'delete' do
    it 'should delete a mail in the INBOX' do
      allow(subject).to receive(:delete) { true }
      allow(subject).to receive(:crawl) { [] }
      expect(subject.crawl.length).to be(0)
    end
  end
end
