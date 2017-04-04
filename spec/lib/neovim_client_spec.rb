require_relative '../../lib/neovim_client'

describe NeovimClient do
  include NeovimClient

  it 'can parse inline ex command arguments' do
    expect(
      subject.parse_command_arguments(:nothing, ['(def goodvar 123)', 0, 0])
    ).to eq(
      '(def goodvar 123)'
    )
  end

  it 'can parse visual mode code blocks' do
    nvim = double('nvim')
    buffer = double('buffer')
    expect(nvim).to receive(:get_current_buffer).twice.and_return(buffer)
    expect(buffer).to receive(:get_line).twice do |line_number|
      case line_number
      when 1
        "first line"
      when 2
        "second line"
      when 3
        "third line"
      end
    end
    expect(
      subject.parse_command_arguments(nvim, [2, 3])
    ).to eq(
      "first line\nsecond line"
    )
  end

  xit 'can print the last stacktrace to a buffer' do
    last_out_message = {"id"=>"ice", "out"=>"             \e[1;31mjava.lang.RuntimeException\e[m: \e[3mUnable to resolve symbol: straam-file in this context\e[m\n\e[1;31mclojure.lang.Compiler$CompilerException\e[m: \e[3mjava.lang.RuntimeException: Unable to resolve symbol: straam-file in this context, compiling:(/home/mikepjb/code/watermarker/src/watermarker/core.clj:88:29)\e[m\n", "session"=>"6fea92ea-461a-43ce-8bac-6b2f464dd564"}
  end
end
