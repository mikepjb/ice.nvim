module Bencode
  def decode(response)
    next_length = nil
    response_array = []

    response[1..-2].split(':').each do |message_part|
      if next_length.nil?
        next_length = message_part.to_i
      else
        payload = message_part[0..(next_length - 1)]
        response_array << payload
        next_meta = message_part[next_length..-1]
        if next_meta =~ /^[0-9].*/
          next_length = next_meta.to_i
        else
          next_length = next_meta[1..-1].to_i
        end
      end
    end
    Hash[*response_array]
  end

  def encode(message)
    encoded_message = 'd'
    message.to_a.flatten.each do |message_part|
      encoded_message << "#{message_part.length}:#{message_part}"
    end
    encoded_message + 'e'
  end

  message =
    {"id" => "test-id",
     "ns" => "boot.user",
     "session" => "a647fb12-54ae-4313-8358-1161810de8f",
     "value" => "#'boot.user/devil"}

      "d2:id7:test-id"\
      "2:ns9:boot.user"\
      "7:session36:a647fb12-54ae-4313-8358-1161810de8f"\
      "35:value17:#'boot.user/devile"
end
