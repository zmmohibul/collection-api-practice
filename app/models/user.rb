class User < ApplicationRecord
  validates :username, presence: true, uniqueness: { case_sensitive: false }
  enum role: { user: "user", admin: "admin" }

  has_secure_password
end