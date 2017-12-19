# -*- coding: utf-8 -*-
class RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

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
  end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
          flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
          set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      respond_with resource, location: after_update_path_for(resource)
    else
      respond_to_failed_update resource
    end
  end

  private

  def failure_response(resource)
    clean_up_passwords resource
    set_minimum_password_length
    resource.errors.full_messages.each {|x| flash[x] = x}
  end

  def respond_to_failed_create(resource)
    failure_response resource
    redirect_to new_registration_path(:user)
  end

  def respond_to_failed_update(resource)
    failure_response resource
    redirect_to edit_registration_path(:user)
  end

  def after_update_path_for(resource)
    edit_registration_path(:user)
  end
end
