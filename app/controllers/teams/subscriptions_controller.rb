# frozen_string_literal: true

require './lib/fast_spring'

module Teams
  class SubscriptionsController < Teams::ApplicationController
    def edit
      redirect_to ::FastSpring.generate_account_management_link(current_user.email)
    end

    def webhook
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
          OpenSSL::Digest.new('sha256'), ENV['FASTSPRING_CRYPTO_KEY'], request.body
        )
      ).chomp

      payload_hash == computed_hash
    end

    def process_webhook_event(webhook_event)
      case webhook_event['type']
      when 'subscription.activated'
        activate_subscription(webhook_event['tags']['teamId'])
        webhook_event['id']
      when 'subscription.deactivated'
        deactivate_subscription(webhook_event['tags']['teamId'])
        webhook_event['id']
      end
    end

    def activate_subscription(team_id)
      TeamSubscription.find_or_initialize_by(team_id: team_id).update!(active: true)
    end

    def deactivate_subscription(team_id)
      TeamSubscription.find_by(team_id: team_id).update!(active: false)
    end
  end
end
