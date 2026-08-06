class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, raise: false
  skip_before_action :verify_signed_out_user, raise: false

  respond_to :json

  def create
    user = User.find_by(email: sign_in_params[:email])

    if user&.valid_password?(sign_in_params[:password])
      token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

      render json: {
        message: "Login realizado com sucesso",
        user: {
          id: user.id,
          nome: user.nome,
          email: user.email,
          first_login: user.first_login
        },
        token: token
      }, status: :ok
    else
      render json: { error: "E-mail ou senha inválidos" }, status: :unauthorized
    end
  end

  def destroy
    if current_user
      current_user.regenerate_jti
    end

    render json: { message: "Logout realizado com sucesso" }, status: :ok
  end

  private

  def sign_in_params
    params.permit(:email, :password)
  end
end
