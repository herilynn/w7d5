class User < ApplicationRecord
    # FIGVAPEBR

    validates(:username, :session_token, uniqueness: true, presence: true)
    validates(:password_digest, presence: true)
    validates(:password, length: {minimum: 6, allow_nil: true})
    before_validation(:ensure_session_token)

    attr_reader :password

    def self.find_by_credentials(username, password)
        # 1. Find user by username
        # 2. check password matches
        # 3. return user or nil

        user = User.find_by(username: username)
        if user && user.is_password?(password)
            return user
        else
            return nil
        end
    end

    def is_password?(password)
        # 1. password_digest is a string -> BCrypt::Password object
        # 2. check BCrypt::Password object to see if password matches
        pword = BCrypt::Password.new(password_digest)
        pword.is_password?(password)
    end

    def password=(password)
        # 1. encrypt password using BCrypt
        # 2. assign password_digest using the encrypted password
        # 3. assign @password
        self.password_digest = BCrypt::Password.create(password)
        @password = password
    end

    def ensure_session_token
        # 1. check if session token exists
        # 2. if it doesnt exist, assign one
        self.session_token ||= generate_unique_session_token
    end

    def reset_session_token!
        # 1. generate a new session token for user
        # 2. save session_token to the database
        # 3. return new session token
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    def generate_unique_session_token
        # 1. generate a random session token
        # 2. see if it exists in the users database
        # 3. if exists, regenerate
        # 4. otherwise return
        token = SecureRandom::urlsafe_base64
        while User.find_by(session_token: token)
            token = SecureRandom::urlsafe_base64
        end
        token
    end


end
