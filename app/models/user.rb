class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:twitter]
  has_many :relations
  has_many :comments
  has_many :movies, dependent: :destroy

  validates :name, presence: true

  def self.from_omniauth(auth)
    # providerとuidでUserレコードを取得する
    # 存在しない場合は、ブロック内のコードを実行して作成する
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.nickname
      user.email = auth.info.email
    end
  end

  # OmniauthCallbacksControllerでsessionに設定した値をuserオブジェクトにコピー
  def self.new_with_session(params, session)
    if session['devise.user_attributes']
      new(session['devise.user_attributes'], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  # providerがある場合はpasswordは要求しない
  def password_required?
    super && provider.blank?
  end

  # プロフィール更新時
  def update_with_password(params, *options)
    # パスワードが空の場合(OmniAuthで登録の場合)
    # パスワードを入力せずに更新できる
    encrypted_password.blank? ? update_attributes(params, *options) : super
  end
end
