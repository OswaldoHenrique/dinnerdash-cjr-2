# -*- coding: utf-8 -*-
class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    if !resource.admin
      if !resource.name.to_s.empty?
        if resource.save
          yield resource if block_given?
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            respond_with resource, location: after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            respond_with resource, location: after_inactive_sign_up_path_for(resource)
          end
        else
          respond_to_failed_create resource
        end
      else
        flash[:error] = "Campo nome não pode estar vazio"
        respond_to_failed_create resource
      end
    else
      flash[:error] = "Você não pode criar administradores"
      respond_to_failed_create resource
    end
  end

  private
  def respond_to_failed_create(resource)
    clean_up_passwords resource
    set_minimum_password_length
    resource.errors.full_messages.each {|x| flash[x] = x}
    redirect_to new_registration_path(:user)
  end
end
