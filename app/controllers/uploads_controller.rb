class UploadsController < ApplicationController
  def index
  end

  def new
  end

  def create
    file = params["upload"]["xml"]
    xml = Nokogiri::XML(file.open) { |c| c.strict.noblanks }
    upload_id = CreatePayments.run(xml.root.children)
    redirect_to upload_payments_path(upload_id)
  end
end
