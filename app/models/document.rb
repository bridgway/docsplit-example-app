require 'split'
require 'prawn'
# require 'docsplit'

class Document < ActiveRecord::Base
  include Split
  mount_uploader :document, DocumentUploader
  
  def images
    Dir.glob("public/#{document.store_dir}/*.png").map{|f| f.gsub('public/', '')}
  end
  
  before_save :set_title
  after_create :extract_images, :extract_text, :extract_pages

def pagecount 
  file = self.document.file.file
  Docsplit.extract_length(file)
end

def author
  file = self.document.file.file
  Docsplit.extract_author(file)
end

def info
  file = self.document.file.file
  Docsplit.extract_info(file)
end

def pdfpaths
  Dir.glob("public/#{document.store_dir}/*_?.pdf") # ok this should now give me the correct pdf paths for prawn #.map{|f| f.gsub('public/', '')}
end

def bible # creates pdf file object but can't seem to access it through preview ...???
  pdf_file_paths = Dir.glob("public/#{document.store_dir}/*_?.pdf") # this works
  Prawn::Document.generate("public/#{document.store_dir}/bible#{self.id}.pdf", {:page_size => 'A4', :skip_page_creation => true}) do |pdf| # check to see if we can put in variable or same directory as other files
  pdf_file_paths.each do |pdf_file|
    if File.exists?(pdf_file)
          pdf_temp_nb_pages = Prawn::Document.new(:template => pdf_file).page_count
          (1..pdf_temp_nb_pages).each do |i|
            pdf.start_new_page(:template => pdf_file, :template_page => i)
        end
      end
    end
  end
end

private
  def set_title
    self.title = Docsplit.extract_title(document.file.file)
  end
end

