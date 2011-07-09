require 'rest_client'

module HasFace
  class Validator < ActiveModel::EachValidator

    def initialize(options)
      @allow_nil, @allow_blank = options.delete(:allow_nil), options.delete(:allow_blank)
      super
    end

    def validate_each(record, attr_name, value)

      # Skip validation if globally turned off
      return if HasFace.enable_validation == false

      image      = record.send(attr_name)
      image_path = image.try(:path) if image.respond_to?(:path)

      # Skip validation if our image is nil/blank and allow nil/blank is on
      return if (@allow_nil && image.nil?) || (@allow_blank && image.blank?)

      # Add an error if the url is blank
      return record.errors.add(attr_name, :no_face) if image_path.blank?

      params   = { :api_key => HasFace.api_key, :api_secret => HasFace.api_secret, :image => File.new(image_path, 'rb') }
      response = RestClient.post(HasFace.detect_url, params)

      # Turn the response into tags
      face_results = JSON.parse(response.body)
      tags         = face_results.try(:[], 'photos').try(:first).try(:[], 'tags') || []

      # Add errors if no tags are present
      unless tags.present?
        record.errors.add(attr_name, :no_face)
      end

    end

  end
end

# Compatibility with ActiveModel validates method which matches option keys to their validator class
ActiveModel::Validations::HasFaceValidator = HasFace::Validator
