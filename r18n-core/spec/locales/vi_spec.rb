# frozen_string_literal: true

describe R18n::Locales::Vi do
  it 'formats Vietnamese time' do
    vi = R18n::I18n.new('vi')
    expect(vi.l(Time.utc(2009, 5, 1, 6, 7, 8), :standard, with_seconds: true))
      .to eq('06:07:08, 01/05/2009')
  end
end
