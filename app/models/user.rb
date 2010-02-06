class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = 'email'
  end # block optional

  attr_accessible :email, :username, :password, :password_confirmation, :old_password
  attr_accessor :validates_password_change, :old_password
  
  validates_uniqueness_of :username
  validates_length_of :username, :in => 2..30, :allow_nil => true, :allow_blank => true
  
  
  # validates password change from account page
  
  validate_on_update do |record|
    if record.validates_password_change
      unless record.password.blank? and record.password_confirmation.blank? and record.old_password.blank?
        record.errors.add :old_password, 'Current password does not match' unless record.valid_password?(record.old_password)
      end
    end
  end

  def active?
    active
  end
  
  def activate!
    self.active = true
    save
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_activation_confirmation!
    reset_perishable_token!
    Notifier.deliver_activation_confirmation(self)
  end
  
  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self)
  end
  
  def to_s
    if username.blank?
      return email
    end
    username
  end
  
  def validate_password= (a)
    self.class.ignore_blank_passwords = a
  end
end
