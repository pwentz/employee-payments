# Employee Payments
This was a technical exercise as part of an interview process.

### Getting Started
* make sure you are running a ruby version of `3.2.0`, if you need a ruby environment manager I recommmend downloading [rbenv](https://github.com/rbenv/rbenv#readme)

* this project requires the foreman gem to handle running multiple dev environments, so if you don't have that gem make sure to run the following:
```
gem install foreman
```

* download bundle dependencies
```
bundle install && npm i
```

* create your Rails database by running the following from the project root
```
rails db:create
```

* the methodfi API key is encrypted via a Rails credentials feature. Normally I would share a key but for convenience purposes I have committed
needed credentials so you can use my key without any additional configuration. However if you'd like to use your own key, run the following:
```
EDITOR="vi" rails credentials:edit --environment=development
```
this will open a YML file where you can the API key you'd like to use instead
```yaml
methodfi:
    api_key: KEY_GOES_HERE
```

* use the following command to run tests
```
rails test test/
```

* finally you can run the dev server from the project root
```
./bin/dev
```

You can now visit [localhost:3000/](http://localhost:3000/)
