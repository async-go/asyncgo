# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Validations' do
    it { is_expected.to validate_presence_of(:action) }
  end

  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:actor).class_name('::User') }
    it { is_expected.to belong_to(:target) }
  end

  it { is_expected.to define_enum_for(:action).with_values(%i[created updated]) }
end
