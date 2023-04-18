class UploadsController < ApplicationController
  def index
    @uploads = Upload.order(created_at: :desc).map { |u| UploadDecorator.new(u) }
  end

  def create
    file = params["upload"]["xml"]
    xml = Nokogiri::XML(file.open) { |c| c.strict.noblanks }
    upload_id = CreatePaymentsInteractor.run(xml.root.children)
    redirect_to upload_payments_path(upload_id)
  end

  def update
    upload = Upload.find(params["id"])
    new_status = params["upload"]["status"] 

    if new_status == "1"
      upload.update!(status: :in_progress)
      ProcessPaymentsInteractor.run(upload.payments)
    elsif new_status == "4"
      upload.update!(status: :discarded)
      upload.payments.update_all(status: :canceled)
    end

    redirect_to "/"
  end
end
