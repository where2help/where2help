class LandingPage
  class Image
    attr_accessor :path, :copyright, :name

    class << self
      attr_reader :images

      IMAGE_COPYRIGHTS = {
        boy: "Getty Images | 501849354 | bodnarchuck",
        girl: "Getty Images | 1294309983 | Valeriy_G",
        hands: "Getty Images | 966404738 | iStock Getty Images Plus Bubball",
        string: "Getty Images | 171053447 | Eplus James Brey",
      }

      DIR_NAME = "landing_page"

      # This will load all image paths so we can just add images when we want
      # Could probably be pulled out if we need random images anywhere else
      def init
        @images = IMAGE_COPYRIGHTS.keys.map do |name|
          img = Image.new
          img.name = name.to_s
          img.copyright = IMAGE_COPYRIGHTS[name]
          img.path = "#{DIR_NAME}/landing-background-#{name}.jpg"
          img
        end
      end

      # This is a global, for all users function so we don't care about
      # how "not random" it is. We would have to save the user's id in a
      # hash or something which is extreme overkill (assuming that this class
      # already isn't)
      def next_image
        images.sample
      end

      def copyright(name)
        IMAGE_COPYRIGHTS[name]
      end
    end
  end
end
