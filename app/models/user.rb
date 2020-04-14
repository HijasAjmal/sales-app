class User < ApplicationRecord
	has_secure_password

	# associations
	has_many :sales
end
