# Has face
An Active model validator to validate that images contain faces by
using the face.com API. The validator works by uploading images to
face.com and then checking to see if any faces were tagged in the photo.
It has been tested with carrierwave attachments but will work with any
attachment type that correctly responds to a `path` method.

## Requirements
- Rails 3.0 or greater
- An account for accessing the face.com API (They are free at the moment)

## Installation
Add has_face to your Gemfile and then bundle

``` ruby
  gem 'has_face'
```

Once installed run the generator to create an initializer

``` ruby
  rails g has_face:install
```

Then open up `config/initializers/has_face.rb` and enter your face.com
API details.

``` ruby
# config/initializers/has_face.rb
  HasFace.configure do |config|
    config.api_key                  = 'your face.com API key'
    config.api_secret               = 'your face.com API secret'
    config.skip_validation_on_error = false
  end
```

## Usage

Simply add a validation to the image you want to ensure has faces:

``` ruby
  class User < ActiveRecord::Base
    validates :avatar, :has_face => true
  end
```

## i18n

Error messages generated are i18n safe. To alter the error message shown
add this to your `config/locale/en.yml`

``` ruby
  en:
    activerecord:
      errors:
        messages:
          no_face: "We couldn't see a face in your photo, try taking another one."
```

## Skipping face validations for testing

Face validations can be turned off for testing by setting the
`enable_validation` config value to false, this is usally best done in
your test config.

``` ruby
  HasFace.enable_validation = false
```

### Contributing

Fork on GitHub and after you’ve committed tested patches, send a pull request.

To get tests running simply run `bundle install` and then `rspec spec`

For the tests to pass you'll need to enter a valid API key and
secret into the spec helper.
