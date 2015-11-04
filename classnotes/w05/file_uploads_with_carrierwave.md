# File Uploads with Carrierwave

So far, when we've wanted to include use-supplied images in our apps, we've had to have a URL stored as a string, pointing at an image on the internet. We've used that URL as the source attribute of an image tage, and it's worked pretty well.

But what if we want our users to be able to supply images from their computers, or if we want to keep a copy of the image on our server (rather than relying on the remote image always existing) so we can transform it (cropping, resizing, or any other manipulation).

Also, images aren't the only files that we might want users to upload -- we could have an app that allows Word or Excel documents to be attached, or PDFs to be shared. How will we prevent users uploading potentially dangerous files (executables and scripts) while allowing those we want.

How can users upload into our app at all?

We *could* roll our own code to handle file uploads from HTML [form file fields](http://guides.rubyonrails.org/form_helpers.html#uploading-files), but there is so much extra functionality around this area, and since we're unlikely to be the first person to ever have this problem, that maybe there's a gem for that...


# Starting with Carrierwave

In fact, there are [lots of other gems](https://www.ruby-toolbox.com/categories/rails_file_uploads) that help us manage uploaded files, and we're going to pick one called 'Carrierwave'.

Carrierwave will take uploaded files from forms, and store them on our server for us, and even has hooks to "do stuff" (whatever we instruct it to do) to the files before storing.

Let's create a new app to experiment with Carrierwave's functionality in. A 'cookbook' would be a familiar topic for the app -- so we'll need a `Recipe` model.

```
  # terminal
  rails new carrierwave_app
  cd carrierwave_app
  rails g scaffold Recipe name:string
  rake db:migrate
```

To use Carrierwave, we just need to add the gem to our gemfile.

```
  # Gemfile
  gem 'carrierwave'
```

And whenever you alter the Gemfile, you need to install with Bundle before you can start your server.

```
  # terminal
  bundle install
  rails s
```


# Generate Uploader

Following the Single Responsibility Principle, Carrierwave extracts the responsibility for handling uploaded file to a class, and gives us a generator to create new uploaders (typically, you would have an uploader for each different need for file uploading -- one for the User's avatar, one for the Recipe's photo, one for each Ingredient's photo, one for the Recipe 'Terms and Conditions of Cooking' [if it had such a thing!]).

We just want one uploader for our app (for now), and that will be for the Recipe's image.

```
  # terminal
  rails g uploader RecipeImage
```

This will create an `app/uploaders/recipe_image_uploader.rb` file for us, which is populated with default content - the minimum needed to store the uploaded files for us.

But as yet, we have not actually tied this uploader to our `Recipe` model -- the fact that the uploader has 'Recipe' in its name is just happenstance; we need to tell Rails how these two classes are related.


# Create migration for image

When we're happily sitting back, with celebratory coffee in hand, looking at our perfectly working file uploader, each of our `Recipe` records will have to have some way on knowing *which* uploaded file belongs to it.

So flashing-back into the present, we will need to add a field to our `Recipe` model to store this (very similar to what we would have done if we were manually storing the URL).

```
  # terminal
  rails g migration AddRecipeImageToRecipes recipe_image:string
```

Check the content of the migration that was created, to ensure it's add a string field called "recipe_image" to our "recipes" table. Then you can migrate.

```
  # terminal
  rake db:migrate
```


# Mount uploader

Now we have a field in the database for an upload to be associated to our Recipe, we will "mount" our uploader onto that new field.

```
  # app/models/recipe.rb
  class Recipe < ActiveRecord::Base
    mount_uploader :recipe_image, RecipeImageUploader
  end
```


# Add file input field to form

The user needs a field on the form to select an file from their local file system.

```
  # app/views/recipes/_form.html.erb
  <div class="field">
    <%= f.label :recipe_image %><br />
    <%= f.file_field :recipe_image %>
  </div>
```

We need to alter our permitted parameters to include the new form attribute too.

```
  # app/controllers/recipes_controller.rb
  def recipe_params
    params.require(:recipe).permit(:name, :recipe_image)
  end
```

And with all those steps completed, we should be able to upload images through the form, and inspect them in the Rails console.


# Add image to view

We want to also be able to use our uploaded, associated image when looking at each recipe.

```
  # app/views/recipes/show.html.erb
  <p>
    <b>Image:</b>
    <%= image_tag @recipe.recipe_image.url %>
</p>
```

```
  # app/views/index.html.erb
  <td><%= image_tag recipe.recipe_image.url %></td>
```

But when we look at the views now, the images are HUGE! (assuming we uploaded huge images :-)


# Manipulating images

The easiest way of altering the image sizes is to control them with CSS.

```
  # app/assets/stylesheets/recipes.css
  img {
    width: 100px;
    height: 100px;
    border: 1px solid #6B1229;
  }
```

But what's wrong with this? The aspect ratio is messed up (because the images are being forced down to 100x100px), and behind the scenes we're still downloading the huge files, and then altering them with CSS. What we really want to do is serve images of the size we want to show.


## Processing uploaders

We said that Carrierwave can process uploaded files for us, and one of the processes we can do is create different versions of each file for different purposes.

For this app, we'll create two extra versions: a small, cropped thumbnail, and a "smaller than the original, but constrained to a 'sensible' size" version.

```
  # app/uploaders/recipe_image_uploader.rb
  include CarrierWave::RMagick

  version :thumb do
    process :resize_to_fill => [100, 100]
  end

  version :medium do
    process :resize_to_fit => [400, 400]
  end

  inside of image uploaders uncomment the line bellow:
```

We've uncommented the `include CarrierWave::RMagick` line, so we need to make sure we have the RMagick gem, and also that ImageMagick is installed on our machine.

```
  # Gemfil
  gem 'rmagick'
```

```
  # terminal
  **brew install imagemagick** # OS X
  sudo apt-get install imagemagick # Ubuntu

  bundle install
```


# Using the versions

At the moment, we're using the default version of the image -- the same as the user uploaded. Change the view to display the thumbnail, and link to the 'medium' version.

Now we can go back into our view and update this line:

```
  # app/views/recipes/show.html.erb
  <%= link_to image_tag(@recipe.recipe_image.thumb.url), @recipe.recipe_image.medium.url %>
```

You can remove the CSS that set the image height and width.

```
  # app/assets/stylesheets/recipes.css
  img {
    // width: 100px;
    // height: 100px;
    border: 1px solid #6B1229;
  }
```

Note: You'll need to upload a new image to test it -- the ones that are already there haven't been processed into multiple versions, have they!


# Remote Image

If you still want to use images from the internet, rather than storing the URL in the database, Carrierwave will take the URL and download it to store locally. Any processing will be performed as with an uploaded file. All you need to do is use a *slightly* different syntax for the field name on the form.

```
  # app/views/recipes/_form.html.erb
  <div class="field">
    <%= f.label :remote_recipe_image_url %><br />
    <%= f.text_field :remote_recipe_image_url %>
  </div>
```

Add that attribute name to the permitted parameters, and enter a URL of an image into the field.

```
  # app/controllers/recipes_controller.rb
  def recipe_params
    params.require(:recipe).permit(:name, :recipe_image, :remote_recipe_image_url)
  end
```

And carrierwave will do the rest for you!

