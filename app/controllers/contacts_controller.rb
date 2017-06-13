class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :set_firm
  before_action :set_information

  # GET /contacts/new
  def new
    @contact = @firm.contacts.build
    @information[:subtitle] = t('view.contacts.new_title', firm: @firm.name)

    new_form_url
  end

  # GET /contacts/1/edit
  def edit
    @information[:subtitle] = t('view.contacts.edit_title', contact: @contact.name, firm: @firm.name)

    edit_form_url
  end

  # POST /contacts
  def create
    @information[:subtitle] = t('view.contacts.new_title', firm: @firm.name)
    @contact = @firm.contacts.build(contact_params)
    @contact.firm_id = @firm.id

    if @contact.save
      flash[:type] = 'success'
      redirect_to @firm, notice: t('view.contacts.correctly_created')
    else
      new_form_url

      render :new
    end
  end

  # PATCH/PUT /contacts/1
  def update
    @information[:subtitle] = t('view.contacts.edit_title', contact: @contact.name, firm: @firm.name)
    if @contact.update(contact_params)
      flash[:type] = 'primary'
      redirect_to @firm, notice: t('view.contacts.correctly_updated')
    else
      edit_form_url

      render :edit
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
    flash[:type] = 'error'
    redirect_to @firm, notice: t('view.contacts.correctly_destroyed')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end
  
    def set_firm
      @firm = Firm.find(params[:firm_id])
    end

    # Form url for new/create methods.
    def new_form_url
      @information[:form_url] = firm_contacts_path(@firm)
    end

    # Form url for edit/update methods.
    def edit_form_url
      @information[:form_url] = firm_contact_path(@firm, @contact)
    end

    # Only allow a trusted parameter "white list" through.
    def contact_params
      params.require(:contact).permit(:name, :area, :details, :firm_id)
    end

    def set_information
      @information = { title: t('activerecord.models.contact.other') }
    end
end
