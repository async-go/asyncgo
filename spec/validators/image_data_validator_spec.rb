# frozen_string_literal: true

require 'spec_helper'

ImageDataValidatable = Struct.new(:body) do
  include ActiveModel::Validations

  validates :body, image_data: true
end

RSpec.describe ImageDataValidator, type: :validator do
  it 'is valid without image data' do
    expect(ImageDataValidatable.new('My amazing day!')).to be_valid
  end

  it 'is invalid with image data' do
    expect(ImageDataValidatable.new('![image.png](data:image/png;base64,abcdefg)')).to be_invalid
  end
end
