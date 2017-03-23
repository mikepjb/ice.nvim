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
          # puts next_meta # erroring at the end of dict
          # XXX misreading dicts containing stack traces
          next if next_meta == 'e' || next_meta.nil?
          next_length = next_meta[1..-1].to_i
        end
      end
    end
    Hash[*response_array]
  end

  def decode_all(response)
    # Sometimes nrepl will pass multiple dictionaries in the same message
    response[0..-2].
      split(/(^|e)d2:/).
      reject { |x| x.empty? || x == 'e' }.
      map.with_index { |x, index| "d2:#{x}#{'e' if index == 0 }" }.
      map { |x| decode(x) }
  end

  def extract_next_keypair(output, response)
    # 7:session36:b9336d5c-abde-4dc3-b555-86628e3d26d6e
    remaining = response
    puts "INRESPONSE #{response}"
    puts "WHAT #{remaining.split(':',2)}"
    puts "exp #{remaining.split(':',2)[1][0..6]}"
    length, remaining = remaining.split(':', 2)
    length = length.to_i
    # failing on this line, can't for the life of me see where [] is called on a nil
    puts "LEN: '#{length}'" # next lines are failing when remaining is an empty string
    puts "REM: '#{remaining}'" # next lines are failing when remaining is an empty string
    key, remaining = [remaining[0..(length-1)], remaining[length..-1]]
    length, remaining = remaining.split(':', 2)
    length = length.to_i
    value, remaining = [remaining[0..(length-1)], remaining[length..-1]]
    output[key] = value
    [output, remaining]
  end

  def no_colon_decode(response)
    output = {}
    current, remaining = [response[0], response[1..-1]]
    if current == 'd' # we are dealing with a dictionary
      while remaining != 'e' # !remaining.empty? # remaining = 'e' # !remaining.empty?
        puts "we are sending: #{remaining}"
        output, remaining = extract_next_keypair(output, remaining)
      end
      output
    end
  end

  def no_colon_decode_all(response)
    # Sometimes nrepl will pass multiple dictionaries in the same message
    # This should not take single messages, no_colon_decode does that the
    # reason for this is that this method does funky stuff fixing dict
    # format for bencode decoding before delegating to no_colon_decode
    response[0..-1].
      split(/(^|e)d2:/).
      reject { |x| x.empty? || x == 'e' }.
      map.with_index { |x, index| "d2:#{x}#{'e' if index == 0 }" }.
      map { |x| no_colon_decode(x) }
  end

  def encode(message)
    encoded_message = 'd'
    message.to_a.flatten.each do |message_part|
      encoded_message << "#{message_part.length}:#{message_part}"
    end
    encoded_message + 'e'
  end
end
