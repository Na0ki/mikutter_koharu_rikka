# test用
class Plugin; def self.create(...); end end

require 'minitest/autorun'
require './mikutter_koharu_rikka.rb'

class GoboGoboTest < Minitest::Test

  def setup
    @小春六花 = MikutterKoharuRikka.new
  end

  def test_gobogobonize?
    assert_equal 'ゴゴボボー！ゴゴボゴボ（ボゴボボ）', @小春六花.gobogobonize('そうだねー！そうなのよ（一人二役）')
  end
end
