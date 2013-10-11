require "spec_helper"

describe Lita::Handlers::Replace, lita_handler: true do
  it { routes("It's cool though. I'm a robot").to(:log) }
  it { routes('s/stupid/awesome').to(:replace) }
  it { routes('s/stupid/awesome/').to(:replace) }
  it { routes('s/stupid/awesome/i').to(:replace) }
  it { routes('s/stupid/awesome/g').to(:replace) }
  it { routes('s/stupid/awesome/ig').to(:replace) }

  describe '#replace' do
    it 'repeats corrected messages matched by the find-and-replace' do
      send_message 'whoops, I did that, whoops'
      send_message 's/whoops/awesome'
      expect(replies.last).to eq('Test User: awesome, I did that, whoops')
    end

    it 'passes along flags' do
      send_message 'Whoops, I did that, whoops'
      send_message 's/whoops/awesome/i'
      expect(replies.last).to eq('Test User: awesome, I did that, whoops')
    end

    it 'globally replaces the pattern when you give it the g flag' do
      send_message 'whoops, I did that, whoops'
      send_message 's/whoops/awesome/g'
      expect(replies.last).to eq('Test User: awesome, I did that, awesome')
    end

    it "ignores commands when they don't match a message" do
      send_message 'whoops, I did that, whoops'
      send_message 's/battletoads/awesome/g'
      expect(replies).to be_empty
    end
  end
end
