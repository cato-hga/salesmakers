class ProtectedController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index
end