def decode_message(response) # XXX Mike: unit test this
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
