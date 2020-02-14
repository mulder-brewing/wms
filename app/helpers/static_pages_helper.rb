module StaticPagesHelper

  def cards
    return [
      Card::BaseCard.new(
        image: "easy.jpg",
        title_key: tkey("easy.title"),
        text_key: tkey("easy.text")
      ),
      Card::BaseCard.new(
        image: "responsive.jpg",
        title_key: tkey("responsive.title"),
        text_key: tkey("responsive.text")
      ),
      Card::BaseCard.new(
        image: "saas.jpg",
        title_key: tkey("saas.title"),
        text_key: tkey("saas.text")
      ),
    ]
  end

  def tkey(key)
    "home.card." << key
  end

end
