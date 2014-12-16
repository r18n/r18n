require File.expand_path('../spec_helper', __FILE__)

describe R18n::Loader::Rails do
  before do
    I18n.load_path = [SIMPLE]
    @loader = R18n::Loader::Rails.new
  end

  it "returns available locales" do
    expect(@loader.available).to match_array([EN, RU])
  end

  it "loads translation" do
    expect(@loader.load(RU)).to eq({ 'one' => 'Один', 'two' => 'Два' })
  end

  it 'does not load faker data' do
    expect(@loader.load(DE)).to be_nil
  end

  it "changes pluralization" do
    expect(@loader.load(EN)).to eq({
      'users' => R18n::Typed.new('pl', {
        0   => 'Zero',
        1   => 'One',
        2   => 'Few',
        'n' => 'Other'
      })
    })
  end

  it "changes Russian pluralization" do
    I18n.load_path = [PL]
    expect(@loader.load(RU)).to eq({
      'users' => R18n::Typed.new('pl', {\
        0   => 'Ноль',
        1   => 'Один',
        2   => 'Несколько',
        'n' => 'Много'
      })
    })
  end

  it "reloads translations on load_path changes" do
    I18n.load_path << OTHER
    expect(@loader.load(RU)).to eq({
      'one'   => 'Один',
      'two'   => 'Два',
      'three' => 'Три'
    })
  end

  it "changes hash on load_path changes" do
    before = @loader.hash
    I18n.load_path << OTHER
    expect(@loader.hash).not_to eq before
  end
end
