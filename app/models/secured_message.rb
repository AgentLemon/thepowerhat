class SecuredMessage < ActiveRecord::Base

  include ActiveModel::Dirty

  belongs_to :post

  before_save do
    if decrypted?
      self.salt = SecureRandom.hex(64)
      crypt_key = ActiveSupport::KeyGenerator.new(key).generate_key(salt)
      crypt = ActiveSupport::MessageEncryptor.new(crypt_key)
      self.encrypted_message = crypt.encrypt_and_sign(message)
    end
    true
  end

  def message
    @name
  end

  def message=(val)
    encrypted_message_will_change!
    @name = val
  end

  def key
    @key
  end

  def key=(val)
    encrypted_message_will_change!
    @key = val
  end

  def decrypted?
    message.present?
  end

  def decrypt_message(key)
    crypt_key = ActiveSupport::KeyGenerator.new(key).generate_key(salt)
    crypt = ActiveSupport::MessageEncryptor.new(crypt_key)

    begin
      self.message = crypt.decrypt_and_verify(self.encrypted_message)
      self.key = key
    rescue
      self.message = nil
    end

    message
  end

end
