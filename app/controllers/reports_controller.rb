class ReportsController < ApplicationController
  before_action :get_upload

  def payor_totals
    # formatted_payload = @upload.payments.processed.payor_totals.map do |grouped|
    @rows = @upload.payments.payor_totals.map do |grouped|
      {
        "source_account_number" => grouped.account_number,
        "total_paid_out" => "$#{grouped.amount.to_f}"
      }
    end

    respond_to do |format|
      format.csv do
        set_csv_headers("payor_totals_#{@upload.id}")
        render "payor_totals"
      end
    end
  end

  def branch_totals
    # formatted = @upload.payments.processed.branch_totals.map do |grouped|
    @rows = @upload.payments.branch_totals.map do |grouped|
      {
        "branch" => grouped.branch_id,
        "total_paid_out" => "$#{grouped.amount.to_f}"
      }
    end

    respond_to do |format|
      format.csv do
        set_csv_headers("branch_totals_#{@upload.id}")
        render "branch_totals"
      end
    end
  end

  private

  def get_upload
    @upload = Upload.find(params[:upload_id])
  end

  def set_csv_headers(filename)
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=#{filename}.csv"
  end
end
