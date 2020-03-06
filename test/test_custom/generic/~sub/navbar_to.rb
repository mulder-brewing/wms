class NavbarTO < GenericTO
  include Includes::IndexPath

  def test(test)
    test.navbar_to_test(self)
  end

end
