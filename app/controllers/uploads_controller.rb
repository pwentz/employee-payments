class UploadsController < ApplicationController
  def index
    @uploads = Upload.all
  end

  def create
    file = params["upload"]["xml"]
    xml = Nokogiri::XML(file.open) { |c| c.strict.noblanks }
    upload_id = CreatePayments.run(xml.root.children)
    redirect_to upload_payments_path(upload_id)
  end

  def update
    upload = Upload.find(params["id"])
    new_status = params["upload"]["status"] 

    if new_status == "1"
      ProcessPaymentsJob.perform_now(params["id"])
    elsif new_status == "4"
      upload.update!(status: :discarded)
    end

    redirect_to "/"
  end
end
