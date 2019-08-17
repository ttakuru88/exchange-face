class PhotosController < ApplicationController
  def index
  end

  @@detector = OpenCV::CvHaarClassifierCascade.load(Rails.root.join('lib', 'haarcascade_frontalface_alt.xml').to_s)

  def create
    image = OpenCV::IplImage.load(params[:photo].path)

    @@detector.detect_objects(image).each do |region|
      # image.reset_roi
    end

    @image_path = "/images/#{SecureRandom.uuid}.png"
    image.save_image(Rails.root.join("public/#{@image_path}").to_s)
  end
end
