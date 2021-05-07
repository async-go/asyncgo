# frozen_string_literal: true

module Services
  module UpdatersHelper
    IMAGEDATA_REGEX = %r{\(data:image/\w+;base64,[^\s)]+\)}i

    def remove_imagedata(text)
      text.gsub(IMAGEDATA_REGEX, '()')
    end
  end
end
