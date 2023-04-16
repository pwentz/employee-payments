class ReportsController < ApplicationController
  before_action :get_upload

  def payor_totals
    # formatted_payload = @upload.payments.processed.payor_totals.map do |grouped|
    formatted = @upload.payments.payor_totals.map do |grouped|
      {
        "source_account_number" => grouped.account_number,
        "total_paid_out" => "$#{grouped.amount.to_f}"
      }
    end

    respond_to do |format|
      format.json { render json: formatted.to_json  }
    end
  end

  def branch_totals
    # formatted = @upload.payments.processed.branch_totals.map do |grouped|
    formatted = @upload.payments.branch_totals.map do |grouped|
      {
        "branch" => grouped.branch_id,
        "total_paid_out" => "$#{grouped.amount.to_f}"
      }
    end

    respond_to do |format|
      format.json { render json: formatted.to_json }
    end
  end

  private

  def get_upload
    @upload = Upload.find(params[:upload_id])
  end
end
