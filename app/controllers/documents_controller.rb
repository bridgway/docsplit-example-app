require 'fileutils'
class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  def bible_create
    @srclist = params[:paths]
    @pdf_file_paths = []
    @srclist.each do |p| 
        p["png"]= "pdf"
        p.insert(0, "public")
        @pdf_file_paths << p
      end

      @pdf_output_path = "public/" + rand.to_s + ".pdf"


    Prawn::Document.generate(@pdf_output_path, {:page_size => 'A4', :skip_page_creation => true}) do |pdf| # check to see if we can put in variable or same directory as other files
    @pdf_file_paths.each do |pdf_file|
      if File.exists?(pdf_file)
            pdf_temp_nb_pages = Prawn::Document.new(:template => pdf_file).page_count
            (1..pdf_temp_nb_pages).each do |i|
              pdf.start_new_page(:template => pdf_file, :template_page => i)
          end
        end
      end
    end
    
    respond_to do |format|
      #format.html # new.html.erb
      #format.json { render json: @document }
      format.js  #{ redirect_to documents_path } #{ render nothing: true }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new
    #@srclist = params[:paths]
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
      format.js 
    end
  end

  # GET /documents/1/edit
  def edit
    @document = Document.find(params[:id])
  end

  # POST /documents
  # POST /documents.json
  def create
    @document = Document.new(params[:document])

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: 'Document was successfully created.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /documents/1
  # PUT /documents/1.json
  def update
    @document = Document.find(params[:id])

    respond_to do |format|
      if @document.update_attributes(params[:document])
        format.html { redirect_to @document, notice: 'Document was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find(params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :no_content }
    end
  end
end
