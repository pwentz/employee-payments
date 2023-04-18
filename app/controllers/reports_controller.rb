class ReportsController < ApplicationController
  def payor_totals
    @rows = scoped_payments.payor_totals.map do |grouped|
      {
        "source_account_number" => grouped.account_number,
        "total_paid_out" => "$#{grouped.amount.to_f}"
      }
    end

    respond_to do |format|
      format.csv do
        set_csv_headers("payor_totals_#{params[:upload_id]}")
        render "payor_totals"
      end
    end
  end

  def branch_totals
    @rows = scoped_payments.branch_totals.map do |grouped|
      {
        "branch" => grouped.branch_id,
        "total_paid_out" => "$#{grouped.amount.to_f}"
      }
    end

    respond_to do |format|
      format.csv do
        set_csv_headers("branch_totals_#{params[:upload_id]}")
        render "branch_totals"
      end
    end
  end

  private

  def scoped_payments
    Upload.find(params[:upload_id]).payments.where(
      status: %i[processing sent canceled]
    )
  end

  def set_csv_headers(filename)
    response.headers['Content-Type'] = 'text/csv'
    response.headers['Content-Disposition'] = "attachment; filename=#{filename}.csv"
  end
end
