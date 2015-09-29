class User < ActiveRecord::Base
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

  def convert_phone_number(phone_number)
    phone_number.tr('\ \-', "")
  end
end
