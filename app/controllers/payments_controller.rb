class PaymentsController < ApplicationController
  def index
    @upload = Upload.find(params[:upload_id])
    @payments = @upload.payments.map { |p| PaymentDecorator.new(p) }

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @payments.to_json }
    end
  end
end
