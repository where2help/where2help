class LandingPage
  class Image
    class << self
      attr_reader :images

      # This will load all image paths so we can just add images when we want
      # Could probably be pulled out if we need random images anywhere else
      def init
        dir_name = "landing_page"
        dir = Rails.root.join("app", "assets", "images", dir_name, "*.jpg")
        @images = Dir[dir].map do |path|
          file = path.split("/").last
          "#{dir_name}/#{file}"
        end
      end

      # This is a global, for all users function so we don't care about
      # how "not random" it is. We would have to save the user's id in a
      # hash or something which is extreme overkill (assuming that this class
      # already isn't)
      def next_image_path
        images.sample
      end
    end
  end
end
