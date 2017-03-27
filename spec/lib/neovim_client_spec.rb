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

  # XXX mock nvim.get_current_buffer.get_line and test visual mode
end
