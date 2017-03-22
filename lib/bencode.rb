module Bencode
  def decode(response)
    next_length = nil
    response_array = []

    response[1..-2].split(':').each do |message_part|
      if next_length.nil?
        next_length = message_part.to_i
      else
        payload = message_part[0..(next_length - 1)]
        puts payload
        response_array << payload
        next_meta = message_part[next_length..-1]
        if next_meta =~ /^[0-9].*/
          next_length = next_meta.to_i
        else
          # puts next_meta # erroring at the end of dict
          # XXX misreading dicts containing stack traces
          next if next_meta == 'e' || next_meta.nil?
          next_length = next_meta[1..-1].to_i
        end
        puts next_length
      end
    end
    Hash[*response_array]
  end

  # XXX test method - remove after speccing out error response messages
  def raw(response)
    response[0..-2].
      split(/(^|e)d2:/).
      reject { |x| x.empty? || x == 'e' }.
      map.with_index { |x, index| "d2:#{x}#{'e' if index == 0 }" }
  end

  def decode_all(response)
    # Sometimes nrepl will pass multiple dictionaries in the same message
    response[0..-2].
      split(/(^|e)d2:/).
      reject { |x| x.empty? || x == 'e' }.
      map.with_index { |x, index| "d2:#{x}#{'e' if index == 0 }" }.
      map { |x| decode(x) }
  end

  def encode(message)
    encoded_message = 'd'
    message.to_a.flatten.each do |message_part|
      encoded_message << "#{message_part.length}:#{message_part}"
    end
    encoded_message + 'e'
  end
end
