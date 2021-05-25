# frozen_string_literal: true

class SubscriptionsController < Teams::ApplicationController
  skip_before_action :verify_authenticity_token

  def update
    return head :unauthorized unless valid_payload?

    successful_events = []

    webhook_events.each do |webhook_event|
      successful_events << process_webhook_event(webhook_event)
    end

    render status: :accepted, plain: successful_events.compact.join('\n')
  end

  private

  def webhook_events
    params.require(:events)
  end

  def valid_payload?
    payload_hash = request.headers['X-FS-Signature']
    computed_hash = Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha256'), crypto_key, request.body.string
      )
    ).chomp

    payload_hash == computed_hash
  end

  def process_webhook_event(webhook_event)
    team_id = webhook_event.dig('data', 'tags', 'teamId')
    case webhook_event['type']
    when 'subscription.activated'
      activate_subscription(team_id)
      webhook_event['id']
    when 'subscription.deactivated'
      deactivate_subscription(team_id)
      webhook_event['id']
    end
  end

  def activate_subscription(team_id)
    Team::Subscription.find_or_initialize_by(team_id: team_id).update!(active: true)
  end

  def deactivate_subscription(team_id)
    Team::Subscription.find_by(team_id: team_id).update!(active: false)
  end

  def crypto_key
    @crypto_key ||= Rails.application.config.x.fastspring.crypto_key
  end
end
