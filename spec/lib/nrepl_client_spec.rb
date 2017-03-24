require_relative '../../lib/nrepl_client'

describe NreplClient do
  include NreplClient
  it 'can construct a message' do
    expect(
      message('an-id', 'a-session', '(important-function-to-call)')
    ).to eq(
      "d4:code"\
      "28:(important-function-to-call)"\
      "2:id5:an-id"\
      "2:op4:eval"\
      "7:session9:a-sessione"
    )
  end
end
