class User < ActiveRecord::Base
  attr_reader :password

  validates :username, presence: true
  validates :password_digest, presence: { message: "Password cannot be blank" }
  validates :password, length: { minimum: 6, allow_nil: true }
  validates :session_token, presence: true

  before_validation :ensure_session_token


  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)

    return nil if user.nil?
  end

  def self.generate_session_token
    SecureRandom::urlsafe_base64
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
end
