module Bencode
  def extract_next_keypair(output, response)
    # 7:session36:b9336d5c-abde-4dc3-b555-86628e3d26d6e
    remaining = response
    length, remaining = remaining.split(':', 2)
    length = length.to_i
    key, remaining = [remaining[0..(length-1)], remaining[length..-1]]
    length, remaining = remaining.split(':', 2)
    if length[0] == 'l' # is value a list?
      length = length[1..-1].to_i
      value, remaining = [remaining[0..(length-1)], remaining[length..-2]]
    else
      length = length.to_i
      value, remaining = [remaining[0..(length-1)], remaining[length..-1]]
    end
    output[key] = value
    [output, remaining]
  end

  def decode(response)
    output = {}
    current, remaining = [response[0], response[1..-1]]
    if current == 'd' # we are dealing with a dictionary
      while remaining != 'e' && remaining.include?(':') # !remaining.empty? # remaining = 'e' # !remaining.empty?
        output, remaining = extract_next_keypair(output, remaining)
      end
      output
    end
  end

  def decode_all(response)
    # Sometimes nrepl will pass multiple dictionaries in the same message
    # This should not take single messages, no_colon_decode does that the
    # reason for this is that this method does funky stuff fixing dict
    # format for bencode decoding before delegating to no_colon_decode
    response[0..-1].
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
