class User < ActiveRecord::Base

	attr_accessor :password

  	before_save :prepare_password
  	after_save :clear_password

  	EMAIL_REGEX = /^.+@.+$/

  	validates :email, :presence => true
	validates_uniqueness_of :username, :email, :on => "create"
	validates_presence_of :password, :username, :allow_blank => true
	validates_confirmation_of :password

	#  validate :check_password incase you want to have custom password parameters

	def self.authenticate(email, pass)
		#unless email.blank
			user = User.find_by_email(email)
		#end

		if user && user.matching_password?(pass)
			user
		else
			nil
		end
	end


	def matching_password?(pass)
		self.password_hash == encrypt_password(pass)
	end

	private

	def prepare_password
		unless password.blank?
			self.password_salt = Digest::SHA1.hexdigest([Time.now, rand].join)
			self.password_hash = encrypt_password(password)
		end
	end

	def clear_password
		self.password = nil
	end
	
	def encrypt_password(pass)
		Digest::SHA1.hexdigest([pass, password_salt].join)
	end
end
