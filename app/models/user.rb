class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  scope :look_for_twitter_friends , -> (twitter_friends_ids) { where( :uid => twitter_friends_ids ) }

  def self.create_with_omniauth(auth)
    create! do |user|
      user.email = "88shiva.s+#{auth["uid"]}@gmail.com"
      user.password = "password"
      user.oauth_token = auth["extra"].access_token.params["oauth_token"]
      user.oauth_token_secret = auth["extra"].access_token.params["oauth_token_secret"]
      user.password_confirmation = "password"
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end

  def twitter
    Twitter::REST::Client.new do |config|
      config.consumer_key        = "6hqYCusqSqZkKgBt9V6QGwddY"
      config.consumer_secret     = "O1SGuMZbXljOFvbm78Ktdlk1sUyiNWuTVYvmm12T9lyIT9DMAx"
      config.access_token        = oauth_token
      config.access_token_secret = oauth_token_secret
    end
  end
  
  private 

  def twitter_friends_ids()
   twitter.friends.map(&:id)
  end
  
end
