class PhotosController < ApplicationController
  def index
  end

  @@detector = OpenCV::CvHaarClassifierCascade.load(Rails.root.join('lib', 'haarcascade_frontalface_alt.xml').to_s)

  def create
    image = OpenCV::IplImage.load(params[:photo].path)
    face_image = OpenCV::IplImage.load(Rails.root.join('lib', 'face.png').to_s)

    @@detector.detect_objects(image, min_size: OpenCV::CvSize.new(image.width * 0.05, image.height * 0.05)).each do |region|
      resized_face = face_image.resize(region)
      image.set_roi(region)
      (resized_face.rows * resized_face.cols).times do |i|
        image[i] = resized_face[i]
      end
      image.reset_roi
    end

    @image_path = "/images/#{SecureRandom.uuid}.png"
    image.save_image(Rails.root.join("public/#{@image_path}").to_s)
  end
end
