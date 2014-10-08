require 'paypal-sdk-adaptivepayments'

PayPal::SDK.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development')

@api = PayPal::SDK::AdaptivePayments.new

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
        :amount => (20.0),
        :email => "wtf-facilitator@wtf.my"
      },
      {
        :amount => 15.0,
        :email => "pledger2-business@wtf.my",
        :primary => false
      }
    ]
  },
  :returnUrl => "http://localhost:3000/samples/adaptive_payments/pay" })

@response = @api.pay(@pay)
p paykey = @response.payKey
p @response.error[0].message
p @response.paymentExecStatus
p @api.payment_url(@response)
"https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_ap-payment&paykey=InsertPayKeyHere"


# execute payment