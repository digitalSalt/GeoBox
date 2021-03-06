class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]
  before_action :ensure_admin, only: :index
  before_action :ensure_not_guest, only: [:new, :create]

  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all

  end

  # GET /documents/1
  # GET /documents/1.json
  def show
  end

  # GET /documents/new
  def new
    @document = Document.new
    @document[:book_id] = params[:book_id]
  end

  # GET /documents/1/edit
  def edit
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(document_params)
    @document[:user_id] = session[:user_id]
    if @document.attachment.file
      @document[:filename] = @document.attachment.file.filename
    else
      @document[:filename] = 'error'
    end
    @document[:latitude] = session[:latitude]
    @document[:longitude] = session[:longitude]

    print(@document.attachment)
    respond_to do |format|
      if @document.save
        format.html { redirect_to root_path, success: 'Document was successfully created.' }
        format.json { render :show, status: :created, location: @document }
      else
        @document.errors.collect { |key, value| "#{key.capitalize} #{value}" }.each do |error|
          flash[:danger] = error
        end
        format.html { render :new }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1
  # PATCH/PUT /documents/1.json
  def update
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to documents_path, success: 'Document was successfully updated.' }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy

    # We need to delete the file off of the server at this point
    @document.remove_attachment

    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, success: 'Document was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def document_params
      params.require(:document).permit(:description, :attachment, :book_id)
    end
end
