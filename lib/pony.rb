require 'rubygems'
require 'net/smtp'
require 'tmail'

module Pony
	def self.mail(to, body)
		mail_inner(:to => to, :body => body)
	end

	####################

	def self.mail_inner(options)
		transport_via_sendmail build_tmail(options)
	end

	def self.build_tmail(options)
		mail = TMail::Mail.new
		mail.to = options[:to]
		mail.from = options[:from] || 'pony@unknown'
		mail.subject = options[:subject]
		mail.body = options[:body] || ""
		mail
	end

	def self.transport_via_sendmail(tmail)
		IO.popen("/usr/sbin/sendmail #{tmail.to}", "w") do |pipe|
			pipe.write tmail.to_s
		end
	end

	def self.transport_via_smtp(tmail)
		Net::SMTP.start('localhost') do |smtp|
			smtp.sendmail(tmail.to_s, tmail.from, tmail.to)
		end
	end
end