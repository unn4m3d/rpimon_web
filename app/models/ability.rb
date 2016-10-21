class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    for role in user.roles
        case role
        when :admin
            can :manage, :all
        end
    end
  end
end
