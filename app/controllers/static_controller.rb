class StaticController < ApplicationController
  def index
  end

  def pay
    @api = PayPal::SDK::AdaptivePayments.new
    Sand.amount = @amount = params[:amount].to_f
    @to_owner = @amount - (0.05*@amount)
    @pay = @api.build_pay({
      :actionType => "PAY_PRIMARY",
      :cancelUrl => "http://#{request.host}:#{request.port}/",
      :currencyCode => "MYR",
      :feesPayer => "SECONDARYONLY",
      :ipnNotificationUrl => "http://#{request.host}:#{request.port}/",
      :receiverList => {
        :receiver => [
          {
            :primary => true, 
            :amount => @amount,
            :email => "wtf-admin@wtf.my"
          },
          {
            :amount => @to_owner,
            :email => "personal1-myr@wtf.my", # sg
            :primary => false
          }
        ]
      },
      :returnUrl => "http://#{request.host}:#{request.port}/static/finally" }) # change the url here

    @response = @api.pay(@pay)

    if @response.success? && @response.payment_exec_status != "ERROR"
      Sand.pay_key = @response.payKey
      redirect_to @api.payment_url(@response)
    else
      @msg = @response.error[0].message
    end
  end

  def finally
    debugger
    @amount = Sand.amount
  end

  def execute_payment
    @api = PayPal::SDK::AdaptivePayments::API.new
    @execute_payment_request = @api.build_execute_payment()
    @execute_payment_request.payKey = Sand.pay_key
    @execute_payment_response = @api.execute_payment(@execute_payment_request)
  end
end
