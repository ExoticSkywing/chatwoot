Rails.application.config.to_prepare do
  Attachment.class_eval do
    def file_url
      file.attached? ? rails_storage_proxy_url(file) : ''
    end

    def thumb_url
      return '' unless file.attached? && image?

      begin
        rails_storage_proxy_url(file.representation(resize_to_fill: [250, nil]))
      rescue ActiveStorage::UnrepresentableError => e
        Rails.logger.warn "Unrepresentable image attachment: #{id} (#{file.filename}) - #{e.message}"
        ''
      end
    end
  end
end
