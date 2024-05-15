class User < ApplicationRecord
  has_many :collections

  validates :username, presence: true, uniqueness: { case_sensitive: false }
  enum role: { user: "user", admin: "admin" }

  has_secure_password

  def as_json(_options = {})
    {
      id: self.id,
      username: self.username
    }
  end
end