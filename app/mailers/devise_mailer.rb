class DeviseMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  layout 'mailer'
  require 'mailgun-ruby'

  def confirmation_instructions(record, token, opts={})
    @user = record
    @token = token
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]
    template = render_to_string(template: "devise/mailer/confirmation_instructions")
    premailer = Premailer.new(template, :with_html_string => true, :warn_level => Premailer::Warnings::SAFE)
    message_params = {:from => "Elaka #{ ENV["DEFAULT_EMAIL"] }", :to => record.email,
                      :subject => "Verify your Elaka email address",
                      :html => template }
    mg_client.send_message ENV["MAILGUN_DOMAIN"], message_params
  end

  def reset_password_instructions(record, token, opt={})
    @user = record
    @token = token
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]
    message_params = {:from => "Elaka <#{ ENV["DEFAULT_EMAIL"] }>", :to => @user.email,
                      :subject => "Reset your Elaka password" }
    mg_client.send_message ENV["MAILGUN_DOMAIN"], message_params
  end

  def unlock_instructions(record, token, opt={})
    @user = record
    @token = token
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]
    message_params = {:from => "Elaka <#{ ENV["DEFAULT_EMAIL"] }>", :to => @user.email,
                      :subject => "Unlock your Elaka account" }
    mg_client.send_message ENV["MAILGUN_DOMAIN"], message_params
  end

  def email_changed(record, opt={})
    @user = record
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]
    message_params = {:from => "Elaka <#{ ENV["DEFAULT_EMAIL"] }>", :to => @user.email,
                      :subject => "Your Elaka email changed" }
    mg_client.send_message ENV["MAILGUN_DOMAIN"], message_params
  end

  def password_change(record, opt={})
    @user = record
    mg_client = Mailgun::Client.new ENV["MAILGUN_API_KEY"]
    message_params = {:from => "Elaka <#{ ENV["DEFAULT_EMAIL"] }>", :to => @user.email,
                      :subject => "Your Elaka password changed" }
    mg_client.send_message ENV["MAILGUN_DOMAIN"], message_params
  end
end