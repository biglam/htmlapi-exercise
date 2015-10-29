# Environment Variables

Environment variables are dynamic named values that can affect the way running processes will behave on a computer. They are part of the environment in which a process runs.

We're using them already to determine the root directories of our applications, and for the name of the logged-in user to our laptops. Even for the name and password for database authentication.

Other services that we use will need us to store more environment variables relating to them - configuration for file uploads, email-sending, and even the configuration of our own app.


## Shell Variables

Our terminal programs already have a host of environment variables set up. We can see them all by simply typing `env` in the shell.

```
  # terminal
  env
```

And you should see something more or less like the following

```
  SHELL=/bin/zsh
  PATH=/Users/michael/.rbenv/shims:/Users/michael/.rbenv/shims:/usr/local/bin:/Applications/Postgres.app/Contents/Versions/9.4/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin  LANG=en_GB.UTF-8
  MY_ENV_VAR=100
  COMMAND_MODE=unix2003
  TERM=xterm
  HOME=/Users/michael
  TMPDIR=/var/folders/8l/48gytrfx43x5pm1245j320980000gp/T/
  USER=michael
  LOGNAME=michael
  __CF_USER_TEXT_ENCODING=0x1F6:0x0:0x0
  ITERM_SESSION_ID=w0t0p0
  SHLVL=1
  PAGER=less -f
  LESS=-R
  LC_CTYPE=en_GB.UTF-8
  EDITOR=subl -w -n
```

As we can see, there are lots of environment variables already; and they're all available to any programs that run in the shell. Ruby, for instance, maps the shell variables to a hash defined with the constant name `ENV` which you can interrogate for individual values.

```
  # irb
  ENV
  => {"RBENV_VERSION"=>"2.1.4", "TERM_PROGRAM"=>"iTerm.app", "TERM"=>"xterm", "SHELL"=>"/usr/local/bin/zsh", "TMPDIR"=>"/var/folders/8l/48gytrfx43x5pm1245j320980000gp/T/", "Apple_PubSub_Socket_Render"=>"/private/tmp/com.apple.launchd.cBnzlcZ0yz/Render", "ZSH"=>"/Users/michael/.oh-my-zsh", "USER"=>"michael", "COMMAND_MODE"=>"unix2003", "RBENV_ROOT"=>"/Users/michael/.rbenv", "SSH_AUTH_SOCK"=>"/private/tmp/com.apple.launchd.8WzEkFbEL5/Listeners", "__CF_USER_TEXT_ENCODING"=>"0x1F6:0x0:0x0", "PAGER"=>"less -f", "LOGNAME"=>"michael", "LC_CTYPE"=>"en_GB.UTF-8", "SECURITYSESSIONID"=>"186a5"} # and more...

  ENV['LOGNAME']
  => "michael"
```

This is one way we can pass information to our Ruby programs. By using environment variables we *could* set up our secret credentials in our shell, and access the ENV hash in our code rather than hard-coding them into our source code.

If we want to share our source code (on Github, etc) using environment variables to store our details locally, and on our production servers we can set *real* values to the same environment variables. Either way, our code just includes the keys of the `ENV` constant, so anyone copying our code may know what we refer to our secrets as, but would never know our secrets.

If you do share your secret keys online, it's trivial for malicious people to expolit them (at your potential, serious cost): [http://wptavern.com/ryan-hellyers-aws-nightmare-leaked-access-keys-result-in-a-6000-bill-overnight](), [http://www.devfactor.net/2014/12/30/2375-amazon-mistake/]()


## Add ENV variables to ~/.zshrc

To do so, we can add something like the following to .zshrc:

```
  # ~/.zshrc
  export AWS_ACCESS_KEY_ID=FF9999999999999999999
  export AWS_SECRET_ACCESS_KEY=asdasdasdlkasldkjlkjdaskjasd
  export WDI_S3_BUCKET=cx3-1-mgp
```

We need to create a new terminal window or run **$ source .zshrc** in order for those new settings to take effect. Verify that they are available in terminal before continuing.

But what's wrong with this?

  - What if you have many sites to manage; you'd have to manage multiple different AWS keys and buckets (for instance) - and work out some way of identifying which was which.

If only there was some tool for maintaining environment variables, and making it easy to have the same key in different projects, with different values for each.


## Dotenv

[dotenv](https://github.com/bkeepers/dotenv) addresses the problems of setting project-specific environment variables by keeping a `.env` file in the root of the project directory.

To get started include the gem in your Gemfile and then populate a `.env` file.

```
  # Gemfile
  gem 'dotenv-rails', groups: [:development, :test]
```

```
  # .env
  AWS_ACCESS_KEY_ID=FF9999999999999999999
  AWS_SECRET_ACCESS_KEY=asdasdasdlkasldkjlkjdaskjasd
  WDI_S3_BUCKET=cx3-1-mgp
```

These variables will be included in the ENV constant as if they were defined in the shell.

Note: Make sure to never commit your .env files - or you'll be back to square one. You can keep a template file by naming it `.env.example` and checking that into git, with further instructions to other developers.

```
  # terminal
  echo .env >> ~/.gitignore_global # assuming the `~/.gitignore_global` file is the configured 'core.excludesfile'
```


## A note on Heroku and environment variables

We'll be using Heroku to deploy our apps. We can't edit our shell profile on Heroku, but they do provide us with environment variable management, and the principle, effect, and interface is the same.

