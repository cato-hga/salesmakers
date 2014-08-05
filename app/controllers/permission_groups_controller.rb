class PermissionGroupsController < ApplicationController

  def index
    authorize PermissionGroup.new
  end
end
