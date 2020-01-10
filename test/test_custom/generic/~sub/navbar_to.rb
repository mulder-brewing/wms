class NavbarTO < GenericTO
  include Includes::IndexPath

  attr_accessor :path

  def test(test)
    test.navbar_to_test(self)
  end

  def path
    @path ||= index_path
  end
end
