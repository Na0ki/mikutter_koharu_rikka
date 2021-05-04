# frozen_string_literal: true

class Plugin::MikutterKoharuRikka
  GOBOGOBOGOBO_EXCEPT = 'ー！？、。'.codepoints
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
    cps = input.codepoints
    [
      cps.first.odd? ? 'ゴ' : 'ボ',
      *cps.map.with_index do |c, i|
        gobo(c, i)
      end,
      *'ゴボ'.each_char.any?(gobo(cps.last, input.size - 1)) ? 'ボ' : nil
    ].join
  end

  def gobo(c, i)
    if Plugin::MikutterKoharuRikka::GOBOGOBOGOBO_EXCEPT.include?(c)
      c.chr(Encoding::UTF_8)
    elsif (c + i).even?
      'ゴ'
    else
      'ボ'
    end
  end
end
