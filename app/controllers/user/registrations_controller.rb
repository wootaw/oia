class User::RegistrationsController < Devise::RegistrationsController
# before_action :configure_sign_up_params, only: [:create]
# before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @options = {}
    @options[:invitation_key] = params[:key] if params[:key].present?
    super do |res|
      res.email = params[:email] if params[:email].present?
    end
  end

  # POST /resource
  def create
    self.resource = User.new(user_params)

    bubbles = Bubbles.new(256)
    File.open(bubbles.save(Rails.root.join('public', AvatarUploader.cache_dir))) do |f|
      self.resource.avatar = f
    end

    if resource.save
      sign_in :user, resource
      return render body: nil
    else
      clean_up_passwords resource
      render json: { code: 401, msgs: resource.errors.full_messages }, status: 401
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end
