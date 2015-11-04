# Sending E-Mail

This isn't about going into Hotmail or GMail to send a message to your mum.

We're going to look at getting our applications to send email, and look at some of the built-in functionality that lets us do that.

What reasons can you think of to have your applications send email?:

  * Notifications to users
  * Password resets
  * Invitations to join


## Action Mailer

"[Action Mailer][1]" is the functionality built into Rails that allows you to send emails from your application. It models emails as objects using mailer classes, and uses views to produce the content of emails.

This pattern means that mailers work very similarly to controllers - They inherit from `ActionMailer::Base` and live in `app/mailers`, and have associated views that appear in `app/views`.

Let's create a new app and try it out. We will want to have our app send registration confirmation emails to new users (to make sure they've given us a valid email address, and to give them some "welcome aboard" information.)

```
  # terminal
  rails new sending_email
  cd sending_email
  rails g scaffold User name email
  rake db:migrate
```

Now we can generate a mailer (no need for any extra gems for this - it's built into Rails).

```
  # terminal
  rails g mailer UserMailer
```

This will create a `user_mailer.rb` file in the `app/mailers` directory, and it will generate a user_mailer view directory.

We will set the mailer object to have a default "from" address - every email this mailer sends will come from this address (unless we over-ride it in idividual methods). In practice, you probably would not want to hard-code an email address in here - this is another ideal use for an environment variable, or to at least have a configuration file so that the address can be different for different developers to test with, and for different deployments to be identifiable.

```
  # app/models/mailers/user_mailer.rb
  class UserMailer < ActionMailer::Base
    default from: "from@example.com"
  end
```

We shall add a method (like an action in a controller) to control what happens when a given email is asked to be delivered - when we want to send a registration confirmation, we'll probably need to know which user has just registered, so we'll pass that as an argument.

```
  # app/models/mailers/user_mailer.rb
  class UserMailer < ActionMailer::Base
    default from: "from@example.com"

    def registration_confirmation(user)
      mail(to: user.email, subject: "Welcome Aboard!")
    end
  end
```

We will need a view for this email, so create a "registration_confirmation.text.erb" file.

```
  # terminal
  touch app/views/user_mailer/registration_confirmation.text.erb
```

Emails can have both/either plain-text or HTML content - the file extension of the view should give you a clue which type the file will generate!

Add some plain-text content to the view.

```
  # app/views/user_mailer/registration_confirmation.text.erb
  Thank you for registering!
```

Now we will need to update our controller to actually send the email.


We will do this in our UsersController, after a new user has been created (a user has registered). Since we will only want this email to be sent to a user after they have registered with our site, we will put the call to our mailer code into the create action of our users controller.

```
  # app/controllers/users_controller.rb
  if @user.save # existing line of code
    UserMailer.registration_confirmation(@user).deliver
    ...
```

We are passing the argument `@user`, to which the registration_confirmation will be sent to.

Now fire-up a Rails server, and create a new user. If nothing breaks, an email *must* have been sent... but where is it?


## Where's the email?

Okay, so Rails has emailling functionality built in; but it doesn't "Just Work". To *really* send an email, you need to configure where your SMTP server is, and what (if any) authentication it needs to accept delivery of emails.

In production, there may be sysops people to look after this stuff for you, but in development, you need to be able to look after yourself.

So Rails defaults to *not attempting to _really_ deliver* emails when your server is running in development. Instead, Rails puts the contents of the email into the log file - and you'll see the output in the console.

Handy. But not *very* handy. It would be better, maybe, if it were more obvious about the emails it's pretending to send.


## There's a gem for that

One of my favourite, simple ways for improving Rails' development handling of emails is to include the "Letter Opener" gem. This is a gem that changes how the emails are shown to you: instead of putting them in the log file, they get opened in a new browser window - shoved right in your face to see.

First add the gem to your development environment and run `bundle` to install it.

```
  # Gemfile
  gem "letter_opener", group: :development
```

Then set the delivery method of emails for your app to use Letter Opener.

```
  # config/environments/development.rb
  config.action_mailer.delivery_method = :letter_opener
```

Run the server again, and create another new user. Now any email will pop up in your browser instead of being sent, and hard-copies of the messages are also stored in `tmp/letter_opener`.

Isn't that nicer?!


## Improve our email

### Dynamic email content

At the moment our email is not very interesting. We really want to take some of the user's information and pass it into our user_mailer view. To do this we will go into the UserMailer class and add some more code to our registration_confirmation action.

```
  # app/models/mailers/user_mailer.rb
  class UserMailer < ActionMailer::Base
    default from: "from@example.com"

    def registration_confirmation(user)
      @user = user
      mail(to: @user.email, subject: "Welcome Aboard!")
    end
  end
```

By setting an instance variable, and assigning the `user` to it, we will have access to our user within our view. Don't forget that our view is ERB, and we can use all the normal behaviour and helpers that we're familiar with.

```
  # app/views/user_mailer/registration_confirmation.text.erb
  Welcome <%= @user.name %>, thank you for registering!
  Edit profile: <%= edit_user_url(@user) %>
```

Before this will work, we need to tell Action Mailer what the host and port for our app is (again - probably best set up in environment variables). If this is not set, the `edit_user_url` helper will raise an error.

```
  # config/environments/development.rb
  config.action_mailer.default_url_options = {
    :host => '127.0.0.1',
    :port => 3000
  }
```

### Richer email content

We can also set up an HTML view, to send a HTML email. This is simply a case of creating the file `registration_confirmation.html.erb`.

```
  # terminal
  touch app/views/user_mailer/registration_confirmation.html.erb
```

```
  # app/views/user_mailer/registration_confirmation.html.erb
  <p>Welcome <%= @user.name %>, thank you for registering!</p>
  <p><%= link_to "Edit profile", edit_user_url(@user) %></p>
```

When you create a new user, notice that Letter Opener puts a helpful link in the corner to switch between the types of email, and if you look in the console, you can see both sets of content sent in one message. This is know as a "multipart" email.


### Attachments

We can also add attachments to our email. We will do this again in the UserMailer class, in our registration_confirmation action.

```
  # app/models/mailers/user_mailer.rb
  class UserMailer < ActionMailer::Base
    default from: "ryan@railscasts.com"

    def registration_confirmation(user)
      @user = user
      attachments["robots_file.txt"] = File.read("#{Rails.root}/public/robots.txt")
      mail(to: "#{@user.name} <#{@user.email}>", subject: "Welcome Aboard!")
    end
  end
```


[1]: http://guides.rubyonrails.org/action_mailer_basics.html
