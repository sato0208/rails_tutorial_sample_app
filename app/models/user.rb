class User < ApplicationRecord
  # ユーザーがマイクロポストを複数所有する
  has_many :microposts, dependent: :destroy
  # 能動的関係に対して1対多 (has_many) の関連付けを実装する 
  has_many :active_relationships, class_name:  "Relationship",
  foreign_key: "follower_id",
  dependent:   :destroy
  # アカウント有効化のコードを追加
  attr_accessor :remember_token, :activation_token, :reset_token

  # email属性を小文字に変換してメールアドレスの一意性を保証
  before_save   :downcase_email
  before_create :create_activation_digest
  validates :name,  presence: true, length: { maximum: 50 }
  # メールフォーマットを正規表現で検証
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  # セキュアなパスワードの実装のためにメソッドの追加
  has_secure_password
  # パスワードの存在性と最小文字数のバリデーション(空のままでも更新できる)
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # トークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

   # アカウントを有効にする
   def activate
    update_columns(activated: FILL_IN, activated_at: FILL_IN)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

    # 試作feedの定義
  # 完全な実装は次章の「ユーザーをフォローする」を参照
  def feed
    # Micropostテーブルからuser_idがidのユーザーをすべて取得
    Micropost.where("user_id = ?", id)
  end

  private

  # メールアドレスをすべて小文字にする
  def downcase_email
    self.email.downcase!
  end

  # 有効化トークンとダイジェストを作成および代入する
  def create_activation_digest
    self.activation_token  = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end