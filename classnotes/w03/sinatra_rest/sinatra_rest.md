# REST

Unfortunately, REST is not about resting, it's about RESTfulness.

It's the abbreviation for "Representational State Transfer".

Representational State Transfer implies transferring "representations". You are using a "representation" of a resource to transfer resource state which lives on the server into application state on the client (and vice versa, to change the state of the resource on the server due to changes in application state).

In a nutshell, REST is about imparting *meaning* into URLs and the actions they get routed to in our apps.


## Mapping REST to CRUD

We need our apps to *do stuff*, and the stuff they do needs to be recorded, and we know that we record this stuff in databases.

In our intro to DBs, we learnt about CRUD, and practiced it by writing SQL statements. Now, our web apps still need to call on those CRUD operations, and we need to work out how to do it in the "simplest", "clearest" way possible.


### What's a 'resource'?

We've used the word 'resource' a couple of times - and it's the "R" of URL - but we haven't really defined it.

A resource is *anything* that we can get to on the web: a page of content, a product on Amazon, a comment we've made on YouTube - they're all resources.

And in the world of the Semantic Web, we use 'resourceful routes' to describe the actions we want to perform with them... like creating new ones; reading and updating existing ones; as well as deleting.


## Routing Resources

The general principle of RESTful routes, is that each URL describes what the expected operation on the resource should be.

In the definition of HTTP (have you been reading those RFCs?!), the different verbs/methods that can be used are specified for certain purposes, and with certain expected side-effects.

For instance, POSTing is intended for 'creating' new resources, while GET should ideally be idempotent - two subsequent GET requests to the same URL should return the same result (or at least, the first shouldn't change anything to affect the second).

Maybe it will be clearer with more comparisons to CRUD... Let's imagine we're managing an online cookbook website, and we have resources for our cookbooks - there's a cookbook DB, with a cookbooks table, and lots of records of individual cookbook books.

Firstly, if we wanted a web page to show *all* the cookbooks in a list, we might give it a path of `/cookbooks` and access it with a GET method.

If we want to look at a specific cookbook, we could pass its ID in the path, and capture it on the server with `/cookbooks/:id`. This would also be a GET.

To alter the name of a cookbook, first, we'd have to make a request to a form that would display for us to change the existing values. We'd have to do the same thing if we wanted to create a new cookbook (though that form would probably start off empty). The paths for these routes would both be GET requests (showing a form doesn't change anything - not until it's submitted it might...) and would either have the ID of the cookbook or not - `/cookbooks/:id/edit` and `/cookbooks/new`.

When we submit those forms, we want the changes we made to be saved on the server. New cookbooks will be created by POSTing to `/cookbooks` (yes, we've used that path before, but that was a GET, and URLs are a combination of the path and method, so it's still unique).

Our edit form will POST to `/cookbooks/:id` (if we're familiar with the HTTP specifications in detail, we might prefer to use a PUT method... but our browsers don't support it).

Finally, we will occasionally want to delete cookbooks that feature food we no longer like to eat, so we would need a route for that. If our browsers allowed us to use the DELETE method, we could have `/cookbooks/:id` as the path, but since they don't, we will POST to `/cookbooks/:id/delete`


## RESTful Routes

So we have seven routes which we use to perform CRUD operations in our web apps:

```
  # Create
  GET   `/cookbooks/new`
  POST  `/cookbooks`

  # Read
  GET   `/cookbooks`
  GET   `/cookbooks/:id`

  # Update
  GET   `/cookbooks/:id/edit`
  POST  `/cookbooks/:id`

  # Delete
  POST  `/cookbooks/:id/delete`
```

...the combination of the method and path makes each unique, so we can use them to represent the behaviour we want to.

REST isn't strict in its implementation that the routes *have* to look *exactly* like this - we've discussed that we could use one verb or another (POST instead of PUT, for instance. We could also use different paths; `POST \cookbooks\create` would be perfectly valid -- but we're lazy, and that extra 'create' on the end of the path isn't disambiguating anything, so we can leave it off).

But it *is* strict that a single URL should be the way we do a single thing.

The URLs we've decicde to list here are very similar to the ones we'll be using in Rails, so it makes sense to start getting into habits we'll be using later.


## REST practice

Okay, so *now* we need a rest.

Let's put REST into practice by creating an app that stores a list of items that need to get done - an online 'todo list'.

