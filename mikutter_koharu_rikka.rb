# frozen_string_literal: true

class Plugin::MikutterKoharuRikka
  GOBOGOBOGOBO_EXCEPT = 'ー！？、。'.chars
end

Plugin.create(:mikutter_koharu_rikka) do
  command(
    :gobogobogobo,
    name: 'ゴボボゴボゴボゴボボボボ',
    condition: lambda { |opt| true },
    visible: true,
    role: :postbox
  ) do |opt|
    box = Plugin[:gtk].widgetof(opt.widget).widget_post.buffer
    text = box.text.strip

    next if text.empty?

    message = rand(100) < 5 ? kaharu_rikkanize : gobogobonize(text)

    compose(opt.world, body: message)
    box.text = ''
  end

  # おしまい！
  def kaharu_rikkanize
    ['ドンドンドン！ぱふーっ！ぱふーっ！', 'アディオース！', 'そうだねー！そうねのよ（一人二役）'].sample
  end

  # 変換ルールが判明するまでのハリボテ翻訳
  def gobogobonize(input)
    chars = input.chars
    [
      go?(chars.first, 0) ? 'ゴ' : 'ボ',
      *chars.map.with_index(&method(:gobo)),
      *'ゴボ'.each_char.any?(gobo(chars.last, input.size - 1)) ? 'ボ' : nil
    ].join
  end

  def gobo(chr, i)
    if Plugin::MikutterKoharuRikka::GOBOGOBOGOBO_EXCEPT.include?(chr)
      chr
    elsif go?(chr, i)
      'ゴ'
    else
      'ボ'
    end
  end

  def go?(chr, i)
    (chr.each_codepoint.first + i).odd?
  end

  def bo?(chr, i)
    !go?(chr, i)
  end
end
