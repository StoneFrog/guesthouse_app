class User < ActiveRecord::Base
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  before_save { self.phone = convert_phone_number(phone)}
  validates :name, presence: true, length: { maximum: 50 }
  validates :surname, presence: true, length: { maximum: 75 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false}
  VALID_PHONE_REGEX = /\A\+?[\d\s\-\(\)]{7,19}\z/
  validates :phone, allow_blank: true, length: { in: 7..20 },
                    format: { with: VALID_PHONE_REGEX }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Removes unnecessary signs from give phone number
  def convert_phone_number(phone_number)
    phone_number.tr('\ \-', "")
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions/.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
