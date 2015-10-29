# Deploying to Heroku

Heroku is a cloud platform service. Essentially it's virtual hosting for your apps. And it's free - as in beer.

To deploy a Rails app to Heroku, it's a fairly straightforward step-by-step process.

First you need to link your machine to your Heroku account - a similar process to what we did with Github.


  		# ensure you're not in a git repo!!! #


  
  	rails new deploy_test -d postgresql
  
  	cd deploy_test

  	rails g scaffold Student name:string
  
  	Subl .

  in config/routes.rb add:  root 'students#index'

  	git init
  	git add .
  	git commit -m "initial commit"
  	heroku create
  	heroku addons:create heroku-postgresql --app APPNAME

  APPNAME is the one provided by heroku, you can change the name of it but for now let's keep it as it is.

  	git push heroku master

  	heroku run rake db:migrate

  	heroku open
```


## Image Aside

By default Rails 4 will not serve your assets. To enable this functionality you need to go into config/application.rb and add this line:

```
  config.serve_static_assets = true
```

Alternatively you can achieve the same result by including the rails_12factor gem in your Gemfile:

```
  gem 'rails_12factor', group: :production
  bundle install
```

This gem will configure your application to serve static assets so that you do not need to do this manually in a config file.
 gem 'rails_12factor'categories/ruby

And more on the rails_12factor gem
https://github.com/heroku/rails_12factor


After adding all the files, make sure you add, commit and push up to heroku again 

		git add .
  		git commit -m "initial commit"
  		git push heroku master
  		

