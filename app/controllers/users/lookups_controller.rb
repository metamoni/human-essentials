class Users::LookupsController < ApplicationController
  layout "devise"
  skip_before_action :authorize_user
  skip_before_action :authenticate_user!

  # TODO: WIP, needs refactoring/extraction
  def create
    if (user = User.find_by(email: params[:user][:email]))
      resource.email = user.email
      render "users/sessions/new", layout: "devise"
    elsif (partner_user = Partners::User.find_by(email: params[:user][:email]))
      resource.email = partner_user.email
      @resource_name = "partner_user"
      render "partner_users/sessions/new", layout: "devise_partner_users"
    end
  end

  # The methods below essentially ducktype this controller so this it looks
  # like a devise controller to devise-y templates, such as shared/links

  def devise_mapping
    @devise_mapping ||= DeviseMappingShunt.new
  end

  def resource
    @resource ||= User.new
  end

  def resource_name
    @resource_name ||= "user"
  end

  helper_method :resource, :resource_name, :devise_mapping

  class DeviseMappingShunt
    def registerable?
      true
    end

    def recoverable?
      true
    end

    def confirmable?
      false
    end

    def lockable?
      false
    end

    def omniauthable?
      false
    end
  end
end
