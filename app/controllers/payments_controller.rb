class PaymentsController < ApplicationController
  def index
    @upload = Upload.find(params[:upload_id])
    @payments = @upload.payments.map { |p| PaymentDecorator.new(p) }

    respond_to do |format|
      format.html { render :index }
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=payments_#{@upload.id}.csv"
        render :index
      end
    end
  end
end
