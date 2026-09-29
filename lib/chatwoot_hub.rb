# frozen_string_literal: true

class ChatwootHub
  def self.installation_identifier
    identifier = InstallationConfig.find_by(name: 'INSTALLATION_IDENTIFIER')&.value
    return identifier if identifier.present?

    identifier = SecureRandom.uuid
    InstallationConfig.create(name: 'INSTALLATION_IDENTIFIER', value: identifier, locked: true)
    identifier
  end

  def self.pricing_plan
    'enterprise'
  end

  def self.pricing_plan_quantity
    100_000
  end

  def self.support_config
    {
      support_website_token: InstallationConfig.find_by(name: 'CHATWOOT_SUPPORT_WEBSITE_TOKEN')&.value,
      support_script_url: InstallationConfig.find_by(name: 'CHATWOOT_SUPPORT_SCRIPT_URL')&.value,
      support_identifier_hash: InstallationConfig.find_by(name: 'CHATWOOT_SUPPORT_IDENTIFIER_HASH')&.value
    }
  end

  def self.instance_config
    {
      installation_identifier: installation_identifier,
      installation_version: Chatwoot.config[:version],
      installation_host: URI.parse(ENV.fetch('FRONTEND_URL', '')).host,
      installation_env: ENV.fetch('INSTALLATION_ENV', ''),
      edition: ENV.fetch('CW_EDITION', '')
    }
  end

  def self.instance_metrics
    {}
  end

  def self.sync_with_hub
    { 'plan' => 'enterprise', 'plan_quantity' => 100_000 }
  end

  def self.register_instance(company_name, owner_name, owner_email)
    true
  end

  def self.send_browser_push(notification_payload)
    true
  end
end
