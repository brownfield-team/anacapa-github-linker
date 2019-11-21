class User < ApplicationRecord
  paginates_per 25
  max_paginates_per 100

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:github]

  has_many :roster_students, dependent: :destroy
  has_and_belongs_to_many :github_repos

  # install rolify
  rolify
  after_create :assign_default_role

  delegate :can?, :cannot?, :to => :ability

  def self.from_omniauth(auth)
    user = where(provider: auth.provider, uid: auth.uid).first
    if user.nil?
      User.create(
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email,
        name: auth.info.name,
        username: auth.info.nickname,
        password: Devise.friendly_token[0,20],
      )
    else
      user.update(
        email: auth.info.email,
        name: auth.info.name,
        username: auth.info.nickname,
      )
    end

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

    self.add_role(:user)
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

  def change_admin_status
    if self.has_role? :admin
      self.remove_role(:admin)
    else
      self.add_role(:admin)
    end

  end

  def change_instructor_status
    if self.has_role? :instructor
      self.remove_role(:instructor)
    else
      self.add_role(:instructor)
    end

  end

  def change_ta_status(course)
    if self.has_role? :ta, course
      self.remove_role :ta, course
    else
      self.add_role :ta, course
    end
  end




end
