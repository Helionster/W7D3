# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, presence: true, uniqueness: true
    validates :password, length: {minimum: 6, allow_nil: true}
    validates :password_digest, presence: true
    validates :session_token, presence: true, uniqueness: true

    attr_reader :password

    def password=(password)
        @password = password

        self.password_digest = BCrypt::Password.create(password)
    end

    def self.find_by_credentials(username,password)
        @user = User.find_by(username: username)

        if @user && @user.is_password?(password)
            @user 
        else  
            nil 
        end
    end

    def ensure_session_token
        self.session_token ||= SecureRandom::urlsafe_base64
    end

    def is_password?(password)
        password_object = BCrypt::Password.new(password_digest)
        password_object.is_password?(password)
    end


end
