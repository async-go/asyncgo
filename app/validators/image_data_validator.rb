# frozen_string_literal: true

class ImageDataValidator < ActiveModel::EachValidator
  IMAGEDATA_REGEX = %r{\(data:image/\w+;base64,[^\s)]+\)}i

  def validate_each(record, attribute, value)
    record.errors.add(attribute, "can't contain embedded markdown images") if IMAGEDATA_REGEX.match?(value)
  end
end
