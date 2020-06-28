class Micropost < ApplicationRecord
  belongs_to :user
  # default_scope（順序を指定するメソッド） created_at:を降順にする
  default_scope -> { order(created_at: :desc) }
  # Micropostモデルに画像を追加
  mount_uploader :picture, PictureUploader
  # user_idが存在する
  validates :user_id, presence: true
  # Micropostモデルのバリデーション
  validates :content, presence: true, length: { maximum: 140 }
end