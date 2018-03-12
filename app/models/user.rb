class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  has_many :roster_students, dependent: :destroy

  # install rolify
  rolify
  after_create :assign_default_role

  delegate :can?, :cannot?, :to => :ability

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.username = auth.info.nickname
      user.password = Devise.friendly_token[0,20]
      user.uid = auth.uid
      user.provider = auth.provider
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def assign_default_role
    # rolify uses this to initally assign user roles.
    if self.id == 1 then
      puts "This is the first user... they should be automatically made an admin..."
      self.add_role(:admin)
    end

    self.add_role(:user) if self.roles.blank?
  end

  def ability
    @ability ||= Ability.new(self)
  end

  def courses
    return courses_enrolled + courses_administrating
  end

  def courses_enrolled
    self.roster_students.map { |student| student.course }
  end

  def courses_administrating
    if has_role? :user
      return []
    else
      return Course.order("name").select { |course| ability.can? :manage, course }
    end
  end

  def join_course(course)

  end

  def get_role
    self.roles.first.name
  end


  def reassign_role(new_role)
    if self.roles.count > 1
        raise "This user has more than one role."
    end
    self.remove_role(self.get_role.to_sym)
    self.add_role(new_role.to_sym)
  end

  def make_admin
    self.add_role(:admin)
  end

  def remove_admin
    self.remove_role(:admin)
  end
end
