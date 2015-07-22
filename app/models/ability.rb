class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.admin?
      can :manage, :all
      cannot [:create, :update], Exam
    else
      can :update, User, id: user.id
      can :create, Exam
      can [:read, :update], Exam, user_id: user.id
      can [:read], Category
    end
  end
end
