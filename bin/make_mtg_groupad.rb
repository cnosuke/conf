require 'rotp'
require "watir"
require 'watir-webdriver'
require 'io/console'
require 'nokogiri'
require 'time'
require 'active_support/all'
require 'openssl'
#require 'pry'

class GHEPullRequest
  GHE_BASE_URL = 'https://ghe.ckpd.co'

  attr_reader :browser, :user, :password
  attr_reader :closed_list, :wip_list

  def initialize(browser: nil, user: nil, password: nil)
    raise ArgumentError unless user && password
    @user, @password = user, password
    @browser = browser || Watir::Browser.new(:chrome)

    @closed_list = get_list(:closed).select{|pr| pr[:date] > Time.now.weeks_ago(1) }
    @wip_list = get_list(:open).select{|pr| pr[:date] > Time.now.weeks_ago(4) }
  end

  def login
    return true if browser.object_id == @login_flag
    browser.goto 'https://ghe.ckpd.co/login'
    browser.text_field(name: 'login').set(user)
    browser.text_field(name: 'password').set(password)
    browser.button(name: 'commit').click

    @login_flag = browser.object_id
    return true
  end

  def visit_pr_url(state)
    login
    url = "https://ghe.ckpd.co/pulls?q=is%3Apr+author%3Ashinnosuke-takeda+is%3A#{state}"
    browser.goto url

    browser.html
  end

  def get_list(state)
    Nokogiri::HTML(visit_pr_url(state)).css('.list-group-item').map do |e|
      name = e.css('.js-navigation-open').text
      url = GHE_BASE_URL + e.css('.js-navigation-open').attr('href').value
      description = e.css('.list-group-item-summary').text.gsub("\n",' ')
      markdown =<<EOB
- [#{name}](#{url})
  - #{description}
EOB
      {
        date: Time.parse(e.css('time').attr('datetime').value),
        url: url,
        name: name,
        description: description,
        markdown: markdown
      }
    end
  end
end

class Groupad
  attr_reader :browser, :user, :password, :mfa_secret

  def initialize(browser: nil, user: nil, password: nil, mfa_secret: nil)
    raise ArgumentError unless user && password && mfa_secret
    @user, @password, @mfa_secret = user, password, mfa_secret
    @browser = browser || Watir::Browser.new(:chrome)
  end


  def login
    return true if browser.object_id == @login_flag

    pin = ROTP::TOTP.new(mfa_secret).at(Time.now - 30)

    browser.goto 'https://adtech.g.cookpad.com'
    browser.text_field(name: 'Email').set(user)
    browser.text_field(name: 'Passwd').set(password)
    browser.button(name: 'signIn').click
    browser.text_field(name: 'smsUserPin').set pin
    browser.button(name: 'smsVerifyPin').click
    sleep 2
    browser.button(id: 'submit_approve_access').click

    @login_flag = browser.object_id
    return true
  end

  def set_template(url, template)
    login
    browser.goto url
    browser.text_field(id: 'page_content').set template
    #browser.button(type: 'submit').click
  end
end

class TemplateBuilder
  def self.build(closed_list: [], wip_list: [])
    template =<<EOB
## Done
#{closed_list.join("\n")}

## WIP
#{wip_list.join("\n")}

## Todo

## KPT

EOB
    return template
  end
end

def decrypt_data(data, password, salt)
  cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
  cipher.decrypt
  cipher.pkcs5_keyivgen(password, salt)
  cipher.update(data) + cipher.final
end

d = {
  salt: "W/t67aHm+ak=",
  encrypted_data: "rwYmRqgyvFV5PzHANKfYrtg6i1a+4l1DFbKDu6H/zvbCMQTgDso78QlB9z7x\ngPD3urbnMR9dPIbK6ypWFVfuTrIzmaJBqe4lKclTthxDccGTEUH56p6D4IXF\nFXMQGRmjJaxTPFzP+itVDCKSY7mMq+ZIpLDcf7aoZ0jfpmABZjQ=",
}

puts 'Enter master password:'
master_password = STDIN.noecho(&:gets).chomp

opt = JSON.parse(
    decrypt_data(
      d[:encrypted_data].unpack('m').first,
      master_password,
      d[:salt].unpack('m').first
    )
  ).symbolize_keys

date = Date.today.strftime("%Y/%m%d")

raise ArgumentError, "Password incorrect." unless opt[:user].present?

if ARGV.first.downcase =~ /ad/
  groupad_url = "https://adtech.g.cookpad.com/pages/meetings/general/%E9%83%A8%E4%BC%9A/#{date}/#{opt[:user]}"
else
  raise ArgumentError
end


browser = Watir::Browser.new(:chrome)

ghe = GHEPullRequest.new(browser: browser, user: opt[:user], password: opt[:ghepw])
template = TemplateBuilder.build(
  closed_list: ghe.closed_list.map{|e| e[:markdown] },
  wip_list: ghe.wip_list.map{|e| e[:markdown] }
  )

groupad = Groupad.new(browser: browser, user: "#{opt[:user]}@cookpad.jp", password: opt[:appspw], mfa_secret: opt[:mfa_secret])
groupad.set_template(groupad_url, template)

puts "open #{groupad_url}"
