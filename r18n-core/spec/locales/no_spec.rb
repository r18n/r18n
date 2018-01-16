# frozen_string_literal: true

describe R18n::Locales::No do
  it 'deprecated' do
    expect { R18n::I18n.new('no') }.to output(
      /R18n::Locales::No.new is deprecated; use R18n::Locales::Nb.new instead./
    ).to_stderr
  end
end
