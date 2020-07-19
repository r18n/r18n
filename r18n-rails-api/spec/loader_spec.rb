# frozen_string_literal: true

describe R18n::Loader::Rails do
  before do
    I18n.load_path = [simple_files]
    @loader = R18n::Loader::Rails.new
  end

  it 'returns available locales' do
    expect(@loader.available).to match_array([DECH, EN, RU])
  end

  it 'loads translation' do
    expect(@loader.load(RU)).to eq('one' => 'Один', 'two' => 'Два')
  end

  it 'loads translation for dialects' do
    expect(@loader.load(DECH)).to eq('a' => 1)
  end

  it 'changes pluralization' do
    expect(@loader.load(EN)).to eq(
      'users' => R18n::Typed.new(
        'pl',
        0 => 'Zero',
        1 => 'One',
        2 => 'Few',
        'n' => 'Other'
      )
    )
  end

  it 'changes Russian pluralization' do
    I18n.load_path = [pl_files]
    expect(@loader.load(RU)).to eq(
      'users' => R18n::Typed.new(
        'pl',
        0 => 'Ноль',
        1 => 'Один',
        2 => 'Несколько',
        'n' => 'Много'
      )
    )
  end

  it 'reloads translations on load_path changes' do
    I18n.load_path << other_files
    expect(@loader.load(RU)).to eq(
      'one' => 'Один',
      'two' => 'Два',
      'three' => 'Три'
    )
  end

  it 'changes hash on load_path changes' do
    before = @loader.hash
    I18n.load_path << other_files
    expect(@loader.hash).not_to eq before
  end
end
