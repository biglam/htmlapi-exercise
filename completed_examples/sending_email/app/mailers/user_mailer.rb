class UserMailer < ApplicationMailer
  default from: 'hr@awesome.example'

  def registration_confirmation(user)
    @user = user

    attachments["robots_file.txt"] = File.read("#{Rails.root}/public/robots.txt")


    mail(to: user.email, subject: "Welcome onboard!")
  end

end
