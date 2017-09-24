require 'fde/mail_crawler/version'
require 'mail'

module FDE
  module MailCrawler

    class Config
      attr_accessor :address,
        :port,
        :domain,
        :user_name,
        :password,
        :authentication,
        :enable_starttls_auto

      def attributes
        {
          address: @address,
          port: @port,
          domain: @domain,
          user_name: @user_name,
          password: @password,
          authentication: @authentication,
          enable_starttls_auto: @enable_starttls_auto
        }
      end
    end

    def self.config
      @@config ||= Config.new
    end

    def self.imap_account
      @@imap_account ||= Mail.defaults do
        retriever_method :imap, FDE::MailCrawler.config.attributes
      end
    end

    def self.configure
      yield self.config
    end

    def self.watch(&block)
      self.crawl.each do |mail|
        yield mail
      end
    end

    def self.crawl
      FDE::MailCrawler.imap_account.all
    end

    def self.delete(message_to_delete)
      account = FDE::MailCrawler.imap_account
      account.find_and_delete do |message|
        if message.subject == message_to_delete.subject
          message.skip_deletion
        end
      end
    end
  end
end
