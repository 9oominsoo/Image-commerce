class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  has_many :image_items, dependent: :nullify #상품의 경우 유저가 삭제되더라도 사라지면 안됨
  has_many :user_items, dependent: :destroy #찜하기는 해당 유저 삭제시 사라져도 됨
  has_many :wishlist, through: :user_items, source: :image_item 
  has_many :orders, dependent: :nullify

  #has_many :paid_items, -> { where(status: paid) }, through: :orders, source: :line_item


  PARAMETERS = [:name]
  
  def self.find_for_oauth(auth, current_user)
    # 이미 있는 계정인지 확인한다.
    email = auth.info.email
    user = User.where(:email => email).first

    unless self.where(email: auth.info.email).exists?
      # 계정이 없다면 새로운 데이터를 생성한다.
      if user.nil?
        user = User.new(name: auth.info.name, email: email ? auth.info.email : "#{auth.uid}@#{auth.provider}.com", password: Devise.friendly_token[0,20])
        user.save!
      end
    end
    user
  end

  def set_chocomush(user_activity, amount)
    #유저가 구매 또는 충전 시 보유 금액 변동 적용
#   분기, 헷갈리지 않게끔 코드 구성 >> charge, pay
#   각 function마다 추가적으로 작성되는 코드가 다를 수 있음 
    (user_activity == "charge") ? self.update(chocomush: self.chocomush += amount) : self.update(chocomush: self.chocomush -= amount)
  end

  def has_item?(item, type)
    case 
    when type == "user_item" then user_items.where(image_item: item).present? #찜한 상품인가?
    when type == "cart_item" then orders.cart.first_or_create.image_items.where(id: item).present? #카트에 담은 상품인가?
    else ImageItem.joins(line_items: :order).where(orders: {status: 1, user_id: self.id}).find_by(id: item).present? #구매한 상품인가?
    end
  end

end
