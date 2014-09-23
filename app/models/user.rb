class User < ActiveRecord::Base
  has_secure_password

  def set_password_reset
    self.code = SecureRandom.urlsafe_base64
    self.expires_at = 4.hours.from_now
    self.save!
  end

  def self.authenticate (email, password)
    User.find_by_email(email).try(:authenticate, password)
  end

  has_one :profile
  has_many :users_events
  has_many :events, through: :users_events
end
