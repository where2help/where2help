class Chatbot
  class Brain
    def hear(msg)
      puts "Just heard msg:\n#{msg.inspect}\n"
      if msg.thumbs_up?
        puts msg.thumb_size
      end
    end
  end
end
