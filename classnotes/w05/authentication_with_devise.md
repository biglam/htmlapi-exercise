# Authentication - in Rails with Devise

Authentication is about making sure you know the identity of the person accessing your site.

Essentially, it's about asking for passwords, or other proof of identity.

But it doesn't guarentee anything... my wife knows my email password, so could "pretend" to be me.


## Create an app to play with authentication

```
  # terminal
  rails new authentication_with_devise
  cd authentication_with_devise
  rails g controller Secret index really_secret
  rails g controller Gossip index
```

```
  # config/routes.rb
  get "public", to: "gossip#index"
  get "secret", to: "secret#index"
  get "really_secret", to: "secret#really_secret"
  root to: "gossip#index"
```

```
  # app/views/secret/index.html.erb
  <p>Shhh! it's a sea-kwet!"</p>
```

```
  # app/views/secret/really_secret.html.erb
  <p>Do not talk about Fight Club!</p>
```

```
  # app/views/gossip/index.html.erb
  <p>Shout it from the roof-tops!</p>
```

```
  # app/views/layouts/application.html.erb
  <nav>
    <ul>
      <li><%= link_to 'gossip', public_path %></li>
      <li><%= link_to 'secret', secret_path %></li>
      <li><%= link_to 'really_secret', really_secret_path %></li>
    </ul>
  </nav>
```

At the moment, there's nothing protecting my secrets; all the routes display whatever user requests them. I need to be able to share my gossip page with the world, while keeping my secret and really secret pages for restricted eyes only.

When we looked at 'filters', we created some structure for authenticating users. Let's remind ourselves of some of this functionality:

- creating users (registering)
- logging in (sessions controller and the 'session' hash)
- logging out (destroying a session)
- other functionality? (password resetting, etc)

We could write this ourselves for every new app we create (we'd refer to this as "rolling our own") or we could use common functionality from a Gem.


Devise is a flexible authentication solution for Rails. We're going to use it instead of 'rolling our own' authentication process - odds are that Devise is more secure and comprehensive than anything we could do.


## Devise

[https://github.com/plataformatec/devise]()

It is composed of 10 modules (although as Devise bring out new versions, this can change):

  * Database Authenticatable: encrypts and stores a password in the database to validate the authenticity of a user while signing in. The authentication can be done both through POST requests or HTTP Basic Authentication.

  * Omniauthable: adds Omniauth (https://github.com/intridea/omniauth) support;

  * Confirmable: sends emails with confirmation instructions and verifies whether an account is already confirmed during sign in.

  * Recoverable: resets the user password and sends reset instructions.

  * Registerable: handles signing up users through a registration process, also allowing them to edit and destroy their account.

  * Rememberable: manages generating and clearing a token for remembering the user from a saved cookie.

  * Trackable: tracks sign in count, timestamps and IP address.

  * Timeoutable: expires sessions that have no activity in a specified period of time.

  * Validatable: provides validations of email and password. It's optional and can be customized, so you're able to define your own validations.

  * Lockable: locks an account after a specified number of failed sign-in attempts. Can unlock via email or after a specified time period.


## Getting Started with Devise

Add Devise to the gemfile, and bundle.

```
  # Gemfile
  gem 'devise'
```

```
  # terminal
  bundle install
```

You need to first run the generator.

```
  # terminal
  rails generate devise:install
```

The generator will install an initializer which describes all of Devise's configuration options and you _MUST_ take a look at it.

It also lists some things you must do (and some things it recommends):

  1. Ensure you have defined default url options in your environments files. Here is an example of default_url_options appropriate for a development environment in config/environments/development.rb:


```
  # config/environments/development.rb
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # In production, :host should be set to the actual host of your application.
```

  2. Ensure you have defined root_url to *something* in your config/routes.rb.
     For example:

```
  # routes.rb
  root to: "home#index"
```

  3. Ensure you have flash messages appearing.
     For example:

```
  # app/views/layouts/application.html.erb
  <p class="notice"><%= notice %></p>
  <p class="alert"><%= alert %></p>
```

Be sure to remove any other flash message notifications from other views (like scaffolded `show` pages, as you only want them displayed once).


When you are done, you are ready to add Devise to any of your models using the generator. We'll add it to a `User` model. This will create a model (if one does not exist) and configure it with default Devise modules.

```
  # terminal
  rails generate devise User
```

```
  # terminal
  rake db:migrate
```

The generator also configures your config/routes.rb file - rake routes to see they're pointing to the Devise controller, and Devise will create some helpers to use inside your controllers and views.

For instance, if you want to remove the functionality for users to click "I forgot my password", edit the `user.rb` file, and remove "recoverable" from the list of Devise modules.


Let's make the secret_controller require authentication...

```
  # app/controllers/secret_controller.rb
  class SecretController < ApplicationController
    before_action :authenticate_user!

    # ... rest of controller code
```

Now you get redirected to a sign-in page, which also has a link to sign-up. If you register, with a password correctly confirmed, you are then registered and able to use the site.

To verify if a user is signed in, use the following helper:

```
  # any Rails controller or view file
  user_signed_in?
```

For the current signed-in user, this helper is available (we **don't** need to have our own in application controller):

```
  # any Rails controller or view file
  current_user
```

After signing in a user, confirming the account or updating the password, Devise will look for a scoped root path to redirect. Example: For a :user resource, it will use user_root_path if it exists, otherwise default root_path will be used. This is what the root_path is needed for.

But you can also overwrite after_sign_in_path_for and after_sign_out_path_for to customize your redirect hooks.

```
  # app/controllers/application_controller.rb
  protected
  def after_sign_in_path_for(resource)
    secret_path
  end

  # apap/views/layouts/application.html.erb
  <div class='login'>
    <% if current_user %>
      <%= current_user.email %>
      <%= link_to "Log out", destroy_user_session_path, method: :delete %>
    <% else %>
      <%= link_to "Sign In", new_user_session_path %>
      <%= link_to "Register", new_user_registration_path %>
    <% end %>
  </div>
```


## Customizing Devise

If you want to customise the Devise views for your app:

```
  # terminal
  rails g devise:views
```

This will add a folder to the views directory, and contains all the default Devise views and partials. Feel free to alter any however you want. If you delete any, Devise will fall back to using the views included in the gem.


## HTTP Basic

A very simple, alternative form of authentication, which doesn't offer any confidentiality of transmitted credentials. So generally, you'd want to add HTTPS to this as a second layer of security.

```
  # app/controllers/secret_controller.rb
  http_basic_authenticate_with name: "secret", password: "letmein"
```

If you add it to the application_controller it would apply to every controller.

You can have different credentials for different actions.

```
  # app/controllers/secret_controller.rb
  http_basic_authenticate_with name: "open", password: "password", only: :really_secret
```

This is a very quick and easy (and insecure) way of restricting access by password.


