# frozen_string_literal: true

class MikutterKoharuRikka
  GOBOGOBOGOBO_EXCEPT = [
    /[()（）ー！？、。\s]/,
    /@\w+(?:@(?:[a-zA-Z\d\-]+\.)+[a-zA-Z\d\-]+)?/
  ]

  # おしまい！
  def koharu_rikkanize
    ['ドンドンドン！ぱふーっ！ぱふーっ！', 'アディオース！', 'そうだねー！そうなのよ（一人二役）'].sample
  end

  # 変換ルールが判明するまでのハリボテ翻訳
  def gobogobonize(input)
    excepts = GOBOGOBOGOBO_EXCEPT.map do |ex|
      ex.match(input)
    end.compact.sort_by { |x| x.begin(0) }
    i = 0
    result = []
    while(i < input.size)
      if excepts&.first&.begin(0) == i
        except = excepts.shift
        result << except[0]
        i = except.end(0)
        excepts = [*excepts, except.regexp.match(input, i)].compact.sort_by { |x| x.begin(0) }
      else
        result << gobo(input[i], i)
        i += 1
      end
    end
    [
      *(result.first == 'ボ' ? 'ゴ' : nil),
      *result,
      *(result.last == 'ゴ' ? 'ボ' : nil)
    ].join
  end

  def gobo(chr, i)
    if go?(chr, i)
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

    小春六花 = MikutterKoharuRikka.new
    message = rand(100) < 5 ? 小春六花.koharu_rikkanize : 小春六花.gobogobonize(text)

    compose(opt.world, body: message)
    box.text = ''
  end
end
