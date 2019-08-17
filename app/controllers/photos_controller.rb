class PhotosController < ApplicationController
  def index
  end

  @@detector = OpenCV::CvHaarClassifierCascade.load(Rails.root.join('lib', 'haarcascade_frontalface_alt.xml').to_s)

  def create
    image = OpenCV::IplImage.load(params[:photo].path)
    face_image = OpenCV::IplImage.load(Rails.root.join('lib', 'icon_blue.png').to_s)

    @@detector.detect_objects(image).each do |region|
      resized_face = face_image.resize(region)
      image.set_roi(region)
      (resized_face.rows * resized_face.cols).times do |i|
        image[i] = resized_face[i] if resized_face[i][0].to_i > 0 || resized_face[i][1].to_i > 0 || resized_face[i][2].to_i > 0
      end
      image.reset_roi
    end

    @image_path = "/images/#{SecureRandom.uuid}.png"
    image.save_image(Rails.root.join("public/#{@image_path}").to_s)
  end
end
