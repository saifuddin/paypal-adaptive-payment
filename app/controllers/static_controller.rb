class StaticController < ApplicationController
  def index
  end

  def pay
    @api = PayPal::SDK::AdaptivePayments.new
    @amount = params[:amount].to_f
    @to_owner = @amount - (0.05*@amount)
    @pay = @api.build_pay({
      :actionType => "PAY_PRIMARY",
      :cancelUrl => "http://localhost:3000/samples/adaptive_payments/pay",
      :currencyCode => "USD",
      :feesPayer => "SECONDARYONLY",
      :ipnNotificationUrl => "http://localhost:3000/samples/adaptive_payments/ipn_notify",
      :receiverList => {
        :receiver => [
          {
            :primary => true, 
            :amount => @amount,
            :email => "wtf-facilitator@wtf.my"
          },
          {
            :amount => @to_owner,
            :email => "pledger2-business@wtf.my",
            :primary => false
          }
        ]
      },
      :returnUrl => "http://localhost:3000/static/finally" })

    @response = @api.pay(@pay)
    p paykey = @response.payKey
    p @response.error[0].message
    p @response.paymentExecStatus
    byebug
    # Access response
    if @response.success? && @response.payment_exec_status != "ERROR"
      @response.payKey
      redirect_to @api.payment_url(@response)
    else
      @response.error[0].message
    end
  end

  def finally
    byebug
    p ''
  end
end
