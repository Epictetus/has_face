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
  config.transfer_method          = :upload
end
```

## Usage

Simply add a validation to the image you want to ensure has faces:

``` ruby
class User < ActiveRecord::Base
  validates :avatar, :has_face => true
end
```

The `allow_nil` and `allow_blank` options are supported:

``` ruby
class User < ActiveRecord::Base
  validates :avatar, :has_face => true, :allow_blank => true
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


## Error Handling

By default has_face will raise either a `HasFace::FaceAPIError` or
`HasFace::HTTPRequestError` on failure. You will need to catch these
errors and then take the appropriate action in your application like so:

``` ruby
begin
  @user = User.create(params[:user])
rescue HasFace::FaceAPIError, HasFace::HTTPRequestError => e
  # Perform some sort of action.
end
```

If you would like to skip valdiation when a HTTP or API error occurs
then simply turn on the `skip_validation_on_error` configuration option:

``` ruby
HasFace.configure do |config|
  config.skip_validation_on_error = true
end
```

If an error does occur then it will be logged as a warning in the log
for your applications current environment.

## Tranfer Methods

The default behavior is to upload images to the face.com API. This
allows images that are not publicly accessible to be validated as well,
has_face also has the option to send the URL of the image to be
validated instead of uploading the data, to use url transering simply
set the configuration option:

``` ruby
HasFace.configure do |config|
  config.transfer_method = :url
end
```

You will also need to set the `ActionController::Base.asset_host` to the
base URL your images are accessible at. This can be done in your
`environment.rb` or the environment for your specific environment, eg
`production.rb` or `staging.rb`.


## Testing has_face

To speed up your test suite, you can disable face validations by setting the
`enable_validation` config value to false, this is usally best done in
your test config.

``` ruby
HasFace.enable_validation = false
```

Has Face supplies a matcher which you can use in your tests, to
enable it, include the matchers module in your rspec config.

``` ruby
RSpec.configure do |config|
  config.include HasFace::Test::Matchers
end
```

Once included he matcher can be used:

``` ruby
context 'validations' do
  it { should validate_has_face_for :avatar }
end
```

The options `allow_blank` and `allow_nil` can also be passed to the matcher:

``` ruby
it { should validate_has_face_for :avatar, :allow_blank => true }
```

## License

Has face is distributed under a standard MIT license, see LICENSE for
further information.

## Contributing

Fork on GitHub and after you’ve committed tested patches, send a pull request.

To get tests running simply run `bundle install` and then `rspec spec`
