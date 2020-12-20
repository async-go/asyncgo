# frozen_string_literal: true

RSpec.shared_examples 'unauthorized user examples' do |alert_message|
  it 'sets the alert flash' do
    subject
    follow_redirect!

    expect(controller.flash[:warning]).to eq(alert_message)
  end

  it 'redirects the user back (to root)' do
    expect(subject).to redirect_to(root_path)
  end
end
