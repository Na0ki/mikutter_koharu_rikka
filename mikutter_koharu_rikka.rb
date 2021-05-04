# frozen_string_literal: true

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
    resp = input.each_codepoint.to_a.map.with_index {|c, i| (c + i).even? ? 'ゴ' : 'ボ' }.join + 'ボ'
    resp = 'ゴ' + resp if resp.start_with?('ボ')
    resp
  end
end
