class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_mail(@contact).deliver
      flash[:notice] = "お問合わせを受け付けました。"
      redirect_to contact_path
    else
      flash[:alert] = "入力に不備があります"
      redirect_to contact_path
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :message)
  end

end
