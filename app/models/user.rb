class User < ApplicationRecord
  # email属性を小文字に変換してメールアドレスの一意性を保証
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  # メールフォーマットを正規表現で検証
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
end
