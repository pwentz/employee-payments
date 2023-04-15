class PaymentsController < ApplicationController
  def index
    @upload = Upload.find(params[:upload_id])
    @payments = @upload.payments.map { |p| PaymentDecorator.new(p) }
  end
end
