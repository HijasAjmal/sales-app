class User < ApplicationRecord
	# has_secure_password

	# associations
	has_many :sales
	has_many :finance_transactions, as: :payee, dependent: :destroy
	has_many :finance_transactions, as: :receiver, dependent: :destroy


  # decrypt user password
  def decrypt_user_password(passwordText)
    salt = self.salt
    password_digest = self.password_digest
    password = AES.decrypt(password_digest, salt)
    (password == passwordText) ? true : false
  end

  # encrypt user password
  def self.encrypt_user_password(passwordText)
    salt = AES.key
    iv = AES.iv(:base_64)
    encrypted_passwrod = AES.encrypt(passwordText, salt, {:iv => iv})
    return encrypted_passwrod, salt
  end

  # retrieve the password
  def retrieve_user_password
    user = User.find(self.id)
    salt = user.salt
    password_digest = user.password_digest
    password = AES.decrypt(password_digest, salt)
    password
  end

	# storing current user session
	def self.current
  	Thread.current[:user]
	end

	def self.current=(user)
  	Thread.current[:user] = user
	end

	# fetch full name of the user
	def full_name
		[self.first_name, self.middle_name, self.last_name].reject(&:blank?).join(" ")
	end



end
