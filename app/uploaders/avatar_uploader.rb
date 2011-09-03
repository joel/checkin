class AvatarUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def sanitize_regexp
    /[^[:word:]\.\-\+]/
  end
        
  version :thumb do
    process :resize_to_fill => [100, 100]
  end
  
  version :medium do
    process :resize_to_fill => [300, 300]
  end

end
