class TransactionsController < ApplicationController
  before_action :gate_way, only: %i[get_client_token]

  def client_token
    token = gateway.client_token.generate(
      customer_id: params[:user_id]
    )

    render json: {token: token}
  end

  def checkout
    result = gateway.transaction.sale(
      :amount => transaction_params[:amount],
      :payment_method_nonce => transaction_params[:nonce],
      :device_data => transaction_params[:device],
      :options => {
        submit_for_settlement: true
      }
    )
    render json: {result: result}
  end

  def gateway
    Braintree::Gateway.new(
      :environment => :sandbox,
      :merchant_id => '7nrb2j4pqn464hh6',
      :public_key => 'k5r2t88mdddbx92s',
      :private_key => '529403db952c635df2b39b2a425778ca',
    )
  end

  private
    def transaction_params
      params.require(:transactions).permit(%i[amount nonce device username])
    end

    def user_params
      params.require(:user).permit(%i[id first_name last_name email])
    end
end
