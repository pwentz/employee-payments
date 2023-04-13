class PaymentsController < ApplicationController
  def index
    upload = Upload.find(params[:upload_id])
    @payments = upload.payments
  end
end
