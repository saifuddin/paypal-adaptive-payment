class Sand
  def self.build(api)
    api.build_pay({
      :actionType => "PAY",
      :cancelUrl => "http://localhost:3000/samples/adaptive_payments/pay",
      :currencyCode => "USD",
      :feesPayer => "SENDER",
      :ipnNotificationUrl => "http://localhost:3000/samples/adaptive_payments/ipn_notify",
      :receiverList => {
        :receiver => [{
          :amount => 1.0,
          :email => "platfo_1255612361_per@gmail.com" }] },
      :returnUrl => "http://localhost:3000/samples/adaptive_payments/pay" })
  end
end
